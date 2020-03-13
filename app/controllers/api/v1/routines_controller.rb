module Api
  module V1
    class RoutinesController < ApplicationController
      before_action :authorize_request
      protect_from_forgery with: :null_session
      respond_to :json

      def index
        if params[:weeks].present?
          routines = @user.routines.where(next_routine_date: (DateTime.now..DateTime.now + 2.weeks),active: true).order(routine_date: :asc).paginate(page: params[:page], per_page: 20)
          render json: { message: "Routines", status: 200, routines: ActiveModelSerializers::SerializableResource.new(routines, each_serializer: RoutineSerializer)}
        else
          routines = @user.routines.paginate(page: params[:page], per_page: 20).order(routine_date: :asc)
          render json: { message: "Routines", status: 200, routines: ActiveModelSerializers::SerializableResource.new(routines, each_serializer: RoutineSerializer)}
        end
      end

      def create
        routine = @user.routines.create(routine_params)
        NextRoutineServices.new(routine).call
        SendNotificationServices.new(routine, @user).call
        render json: { message: "Routine created sucessfully", status: 200, routine: RoutineSerializer.new(routine,root: false)}
      end

      def show
        routine = @user.routines.find_by(id: params[:id])
        if routine.present?
          render json: { message: "Routine", status: 200, routine: RoutineSerializer.new(routine,root: false)}
        else
          render json: { message: "Routine not found", status: 400}
        end
      end

      def update
        routine = @user.routines.find_by(id: params[:id])
        if routine.present?
          old_routine_frequency = routine.frequency
          old_routine_date = routine.routine_date
          old_routine_time = routine.routine_time
          routine.update(routine_params)
          new_routine_frequency = routine.frequency
          new_routine_date = routine.routine_date
          new_routine_time = routine.routine_time
          if ((old_routine_frequency != new_routine_frequency) || (old_routine_date != new_routine_date) || (old_routine_time != new_routine_time))
            NextRoutineServices.new(routine).call
            SendNotificationServices.new(routine, @user).call
          end
          render json: { message: "Routine updated", status: 200, routine: RoutineSerializer.new(routine,root: false)}
        else
          render json: { message: "Routine not found", status: 400}
        end
      end

      def destroy
        routine = @user.routines.find_by(id: params[:id])
        if routine.present?
          routine.destroy
          render json: { message: "Routine deleted", status: 200}
        else
          render json: { message: "Routine not found", status: 400}
        end
      end

      def routines_dates
        start_date = Date.parse(params[:start_date]) if params[:start_date].present?
        end_date = Date.parse(params[:end_date]) if params[:end_date].present?
        selected_date = Date.parse(params[:selected_date]).to_time.to_i
        result = RoutineDatesServices.new(@user, start_date, end_date, selected_date).call
        render json: { message: "Routines", status: 200 , routines_date: result.routine_dates, routines: ActiveModelSerializers::SerializableResource.new(result.routines, each_serializer: RoutineSerializer)}
      end

      private

      def routine_params
        params.require(:routine).permit(:name, :description, :routine_date, :frequency, :active, :routine_time, :reminder_notification_time)
      end

    end
  end
end
