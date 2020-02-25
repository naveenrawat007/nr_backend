module Api
  module V1
    class Devise::Users::PasswordsController < DeviseController
      protect_from_forgery with: :null_session
      respond_to :json

      def forget_password
        user = (User.find_by(email: params[:user][:username]) or User.find_by(phone_no: params[:user][:username].to_i))
        if user.present?
          user.update(otp_code: rand(100000...999999))
          render json: { message: "OTP sent to your registered email", status: 200, user: UserSerializer.new(user,root: false)}
          Sidekiq::Client.enqueue_to_in("default",Time.now, OtpSendWorker, user.id)
        else
          render json: { message: "User not found", status: 400}
        end
      end

      def update_profile
        user = User.find_by(id: params[:user][:user_id]) if params[:user][:user_id].present?
        if user.update(user_params)
          token = JWT.encode({user_id: user.id},Rails.application.secrets.secret_key_base, 'HS256')
          if params[:user][:billing_address].present?
            user.update(billing_address: params[:user][:billing_address])
          end
          user.update(otp_verified: true)
          render json: { message: "User Update Sucessfully", status: 200,  user: UserSerializer.new(user,root: false, serializer_options: {token: token})}
        else
          render json: { message: "User not found", status: 404}
        end
      end

      private

      def user_params
        params.require(:user).permit(:first_name, :phone_no ,:last_name, :email, :password, :step_no, :shipping_address, :billing_address)
      end

    end
  end
end
