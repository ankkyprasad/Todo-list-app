module Api
  module V1
    class TasksController < ApplicationController
      include JSONAPI::ActsAsResourceController

      before_action :authenticate_user
      before_action :check_task_belongs_to_user, only: %i[show update destroy]
      rescue_from ActiveRecord::RecordNotFound, with: :task_not_found

      def index
        task = @user.tasks
        render json: {data: task}
      end

      def create
        task = Task.create(name: params[:name], user_id: @user.id)
        if task.save
          render json: {message: 'task created'}, status: :created
        else
          render json: {error: task.errors}, status: :unprocessable_entity
        end
      end

      def update
        task = Task.find(params[:id])
        if task.update(task_params)
          render status: :no_content
        else
          render json: {error: task.errors}, status: :unprocessable_entity
        end
      end

      private
      
      def authenticate_user
        token = get_bearer_token
        user_id = AuthenticationTokenService.decode(token)
        @user = User.find(user_id)
        rescue
          render status: :unauthorized
      end

      def get_bearer_token
        request.headers['Authorization'].split(' ').last
      end

      def task_not_found
        render json: {message: "task not found"}, status: :not_found
      end

      def task_params
        params.require(:task).permit(:name, :completed)
      end

      def check_task_belongs_to_user
        task = Task.find(params[:id])
        if task.user_id != @user.id
          task_not_found
        end
      end

    end
  end
end

