module Api
  module V1
    class NotificationsController < ApplicationController
      before_action :authorize_request
      protect_from_forgery with: :null_session
      respond_to :json

      def index
        routines = @user.routines
        routine_notifications = []
        routines.each do |routine|
          if routine.notifications.present?
            notification = routine.notifications.last
            routine_notifications.append({title: notification.title ,description: notification.description, frequency: routine.frequency, name: routine.name, created_at: notification.created_at.strftime("%b %d, %Y %I:%M %p")})
          end
        end
        render json: { message: "Notifications", status: 200, notifications: routine_notifications}
      end

    end
  end
end
