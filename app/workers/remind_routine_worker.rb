class RemindRoutineWorker
  include Sidekiq::Worker

  def perform(device_type, device_token, message, title)
    if device_type == "ios"
      APNS.port = 2195
      APNS.pem  = pem
      APNS.pass = ''
      APNS.host = APP_CONFIG['apn_host']
      begin
        APNS.send_notification(device_token, :alert => { title: title, body: message} , :badge => 1, :sound => 'default')
      rescue Exception => ex
        return false
      end
    elsif device_type == "android"
      require 'fcm'
      fcm = FCM.new('AAAA0ppfMK8:APA91bGIDAzeQIXgHILzeC6AxoSMrLUKR4uuG5bWTPAl3YI-_VXN2Ns8UJrHIYaRz3dM4mx9OEHag8-VaAZD7nqcyDQ2TB7wbLCnVY8h7j4MvNuo0GWkjLj8qi_pgzoPmF-qYsuCK4Vv')
      registration_ids = [device_token]
      options = {data: {title: title, body: message}}
      fcm.send(registration_ids, options)
    end
  end

  def pem
    return pem
  end

end
