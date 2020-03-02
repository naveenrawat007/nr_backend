module Api
  module V1
    class Devise::Users::SessionsController < DeviseController
      protect_from_forgery with: :null_session
      respond_to :json

      def create
        user = User.find_by(email: params[:user][:username])
        if user.present?
          token = JWT.encode({user_id: user.id},Rails.application.secrets.secret_key_base, 'HS256')
          if user.valid_password?(params[:user][:password])
            if user.otp_verified
              user.update(device_token: params[:user][:device_token])
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

    end
  end
end
