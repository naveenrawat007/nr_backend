class UserMailer < ApplicationMailer

  def otp_send(user)
    @email = user.email
    @name = user.first_name
    @otp_code = user.otp_code
    mail(to:user.email, subject: "Verify Email")
  end

  def feedback(fname,lname,phone,email,query)
    @email = email
    @fname = fname
    @lname = lname
    @phone = phone
    @query = query
    mail(to:ENV["SUPPORT_EMAIL"], subject: "Support")
  end

end
