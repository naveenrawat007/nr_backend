class UserMailer < ApplicationMailer

  def otp_send(user)
    @email = user.email
    @otp_code = user.otp_code
    mail(to:user.email, subject: "OTP CODE")
  end

end
