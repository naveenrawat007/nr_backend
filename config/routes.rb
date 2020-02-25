Rails.application.routes.draw do

  namespace 'api' do
    namespace "v1", constraints: ApiConstraint.new(version: 1) do
      devise_for :users, controllers: {registrations:"api/v1/devise/users/registrations", sessions:"api/v1/devise/users/sessions", passwords:"api/v1/devise/users/passwords"}
        devise_scope :user do
          post "/users/verify_otp" => "devise/users/sessions#otp_verify"
          post "/users/forget_password" => "devise/users/passwords#forget_password"
          patch "/users/update_profile" => "devise/users/passwords#update_profile"
          post "/users/resend_otp" => "devise/users/registrations#resend_otp"
          get "/user_info" => "devise/users/registrations#get_user_info"
        end
    end
  end

end
