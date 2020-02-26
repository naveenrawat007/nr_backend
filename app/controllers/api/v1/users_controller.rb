module Api
  module V1
    class UsersController < ApplicationController
      before_action :authorize_request, only: :get_user_info
      protect_from_forgery with: :null_session
      respond_to :json

      def otp_verify
        user = User.find_by(id: params[:user][:user_id]) if params[:user][:user_id].present?
        otp = params[:user][:otp_code].to_i if params[:user][:otp_code].present?
        if user.present?
          if user.otp_code == otp
            user.update(otp_verified: true)
            render json: { message: "OTP verified sucessfully", status: 200, user: UserSerializer.new(user,root: false)}
          else
            render json: { message: "Invalid OTP", status: 400}
          end
        else
          render json: { message: "User not found", status: 400}
        end
      end

      def update_profile
        user = User.find_by(id: params[:user][:user_id]) if params[:user][:user_id].present?
        if user.update(user_params)
          token = JWT.encode({user_id: user.id},Rails.application.secrets.secret_key_base, 'HS256')
          user.update(otp_verified: true)
          render json: { message: "User Update Sucessfully", status: 200,  user: UserSerializer.new(user,root: false, serializer_options: {token: token})}
        else
          render json: { message: "User not found", status: 404}
        end
      end

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

      def resend_otp
        user = User.find_by(id: params[:user][:user_id])
        if user.present?
          user.update(otp_code: rand(100000...999999))
          render json: {message: "OTP send to your registered email", status: 200 }
          Sidekiq::Client.enqueue_to_in("default",Time.now, OtpSendWorker, user.id)
        else
          render json: {message: "User not found", status: 400 }
        end
      end

      def get_user_info
        render json: { message: "User Details", status: 200, user: UserSerializer.new(@user,root: false)}
      end

      private

      def user_params
        params.require(:user).permit(:first_name, :phone_no ,:last_name, :email, :password)
      end

    end
  end
end
