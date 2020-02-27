module Api
  module V1
    class RoutinesController < ApplicationController
      before_action :authorize_request
      protect_from_forgery with: :null_session
      respond_to :json

      def index
        routines = @user.routines.where(routine_date: (Date.today..Date.today + 2.weeks)).order(routine_date: :asc)
        render json: { message: "Routines", status: 200, routines: ActiveModelSerializers::SerializableResource.new(routines, each_serializer: RoutineSerializer)}
      end

      def all_routines
        routines = @user.routines
        if routines.present?
          render json: { message: "All Routines", status: 200, routines: ActiveModelSerializers::SerializableResource.new(routines, each_serializer: RoutineSerializer)}
        else
          render json: { message: "No Routines", status: 400}
        end
      end

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
          render json: { message: "Routine updated", status: 200}
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

      private

      def routine_params
        params.require(:routine).permit(:name, :description, :routine_date, :frequency)
      end

    end
  end
end
