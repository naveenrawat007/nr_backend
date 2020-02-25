module Api
  module V1
    class Devise::Users::PasswordsController < DeviseController
      protect_from_forgery with: :null_session
      respond_to :json

      



      private

      def user_params
        params.require(:user).permit(:first_name, :phone_no ,:last_name, :email, :password)
      end

    end
  end
end
