class OtpSendWorker
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find(user_id)
    UserMailer.otp_send(user).deliver_now
  end
end
