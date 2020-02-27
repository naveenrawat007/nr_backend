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
      fcm = FCM.new(APP_CONFIG['fcm_key'])
      registration_ids = [device_token] # an array of one or more client registration tokens
      options = {data: {title: title, body: message}}
      response = fcm.send(registration_ids, options)
    end
  end

  def pem
    return pem
  end

end
