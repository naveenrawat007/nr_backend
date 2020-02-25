class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def authorize_request
   header = request.headers['Authorization']
   if header == ""
     render json: { message: "Empty token", status: 400 ,data: nil}
   elsif header!=""
     header = header.split(' ').last if header
     begin
       decoded = JWT.decode(header,Rails.application.secrets.secret_key_base,false)
       @user = User.find(decoded.first['user_id'])
     rescue ActiveRecord::RecordNotFound => e
       render json: { message: e.message, status: 401 ,data: nil}
     rescue JWT::DecodeError => e
       render json: { message: e.message, status: 500, data: nil }
     end
   end
 end

end
