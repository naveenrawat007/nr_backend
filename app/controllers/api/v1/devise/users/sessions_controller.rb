module Api
  module V1
    class Devise::Users::SessionsController < DeviseController
      protect_from_forgery with: :null_session
      respond_to :json

      def create
        user = (User.find_by(email: params[:user][:username]) or User.find_by(phone_no: params[:user][:username].to_i))
        if user.present?
          token = JWT.encode({user_id: user.id},Rails.application.secrets.secret_key_base, 'HS256')
          if user.valid_password?(params[:user][:password])
            if user.otp_verified
              render json: {message: "Login sucessfully",user: UserSerializer.new(user,root: false, serializer_options: {token: token}), status: 200}
            else
              user.update(otp_code: rand(100000...999999), device_type: params[:user][:device_type] )
              render json: { message: "please verify your account first", status: 200, user: UserSerializer.new(user,root: false, serializer_options: {token: token})}
              Sidekiq::Client.enqueue_to_in("default",Time.now, OtpSendWorker, user.id)
            end
          else
            render json: { message: "Invalid password or email", status: 400}
          end
        else
          render json: { message: "User not found", status: 404}
        end
      end

      def otp_verify
        user = User.find_by(id: params[:user][:user_id]) if params[:user][:user_id].present?
        otp = params[:user][:otp_code].to_i if params[:user][:otp_code].present?
        if user.present?
          if user.user_otp == otp
            user.update(otp_verified: true)
            render json: { message: "OTP verified sucessfully", status: 200, user: UserSerializer.new(user,root: false)}
          else
            render json: { message: "Invalid OTP", status: 400}
          end
        else
          render json: { message: "User not found", status: 400}
        end
      end

    end
  end
end
