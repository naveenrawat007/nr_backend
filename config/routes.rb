Rails.application.routes.draw do
  root "home#index"
  namespace 'api' do
    namespace "v1", constraints: ApiConstraint.new(version: 1) do
      resources :routines
      resources :notifications
      devise_for :users, controllers: {registrations:"api/v1/devise/users/registrations", sessions:"api/v1/devise/users/sessions", passwords:"api/v1/devise/users/passwords"}

      post "/verify_otp" => "users#otp_verify"
      post "/forget_password" => "users#forget_password"
      patch "/update_profile" => "users#update_profile"
      post "/resend_otp" => "users#resend_otp"
      get "/user_info" => "users#get_user_info"
      get "/day_routines" => "routines#day_routines"
      get "/month_routines" => "routines#month_routines"
      patch "/update_password" => "users#update_password"
    end
  end

end
