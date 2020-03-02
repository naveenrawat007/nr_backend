module Api
  module V1
    class RoutinesController < ApplicationController
      before_action :authorize_request
      protect_from_forgery with: :null_session
      respond_to :json

      def index
        if params[:weeks].present?
          routines = @user.routines.where("next_routine_date <= ? and active = ?", Date.today + 2.weeks + 1.day, true).order(routine_date: :asc)
          render json: { message: "Routines", status: 200, routines: ActiveModelSerializers::SerializableResource.new(routines, each_serializer: RoutineSerializer)}
        else
          routines = @user.routines.order(routine_date: :asc)
          render json: { message: "Routines", status: 200, routines: ActiveModelSerializers::SerializableResource.new(routines, each_serializer: RoutineSerializer)}
        end
      end

      # def all_routines
      #   routines = @user.routines
      #   if routines.present?
      #     render json: { message: "All Routines", status: 200, routines: ActiveModelSerializers::SerializableResource.new(routines, each_serializer: RoutineSerializer)}
      #   else
      #     render json: { message: "No Routines", status: 400}
      #   end
      # end

      def create
        routine = @user.routines.create(routine_params)
        NextRoutineServices.new(routine).call
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
          routine.update(routine_params)
          # NextRoutineServices.new(routine).call
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

      # def month_routines
      #   start_date = Date.parse(params[:start_date]) if params[:start_date].present?
      #   end_date = Date.parse(params[:end_date]) if params[:end_date].present?
      #   routines = @user.routines.where(routine_date: (start_date..end_date))
      #   all_routines = []
      #   routine_dates = []
      #   routines.each do |routine|
      #     frequency = routine.frequency
      #     new_date = routine.routine_date
      #     if frequency == 'daily'
      #       while new_date <= (end_date + 1.day)
      #         routine_dates.append({date: new_date.strftime("%d/%m/%Y %H:%M %p"), routine: all_routines})
      #         new_date = new_date + 1.day
      #       end
      #     elsif frequency == 'Weekly'
      #       while new_date <= end_date + 1.day
      #         routine_dates.append({date: new_date.strftime("%d/%m/%Y %H:%M %p"), routine: routine.id})
      #         new_date = new_date + 1.week
      #       end
      #     end
      #   end
      #   render json: { message: "Routines", status: 200 , routines_date: routine_dates.uniq}
      # end

      private

      def routine_params
        params.require(:routine).permit(:name, :description, :routine_date, :frequency, :active)
      end

    end
  end
end
