module Api
  module V1
    class Devise::Users::RegistrationsController < DeviseController
      before_action :authorize_request, only: :get_user_info
      protect_from_forgery with: :null_session
      respond_to :json

      def create
        if !User.exists?(email: sign_up_params[:email]) and !User.exists?(phone_no: sign_up_params[:phone_no] )
          build_resource(sign_up_params)
          resource.otp_code = rand(100000...999999)
          if resource.save
            token = JWT.encode({user_id: resource.id},Rails.application.secrets.secret_key_base, 'HS256')
            Sidekiq::Client.enqueue_to_in("default",Time.now, OtpSendWorker, resource.id)
            render json: { message: "Account Created please verfiy your account to login", status: 200, user: UserSerializer.new(resource,root: false, serializer_options: {token: token})}
          else
            render json: { message: resource.errors.full_messages[0], status: 400}
          end
        else
          render json: { status: 400, message: "User already exists"}
        end
      end

      protected

      def build_resource(hash=nil)
        self.resource = resource_class.new_with_session(hash || {}, session)
      end

      def sign_up_params
        params.require(:user).permit(:first_name, :phone_no ,:last_name, :email, :password, :device_type, :device_token)
      end

    end
  end
end
