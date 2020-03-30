Rails.application.routes.draw do
  require 'sidekiq/web'
  require 'sidekiq/cron/web'
  mount Sidekiq::Web => '/sidekiq'
  root "home#index"
  get "/privacy-policy" => "home#privacy_policy"
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
      get "/routines_dates" => "routines#routines_dates"
      patch "/update_password" => "users#update_password"
    end
  end

end
