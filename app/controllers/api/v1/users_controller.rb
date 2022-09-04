module Api
  module V1
    class UsersController < ApplicationController
      include JSONAPI::ActsAsResourceController

      before_action :user_not_found, except: %i[index login register]

      def login
        user = User.find_by(username: params[:username])

        if !user
          return render json: {message: "invalid username or password"}, status: :unprocessable_entity
        end

        user_hash = BCrypt::Password.new(user.password_digest)

        if user_hash == params[:password]
          token = AuthenticationTokenService.encode(user.id)
          render json: {token: token}, status: :created
        else
          render json: {message: "invalid username or password"}, status: :unprocessable_entity
        end
      end
      
      def register
        user_exists = User.exists?(username: params[:username])

        if user_exists
          return render json:{message: 'user already exists'}, status: :unprocessable_entity
        end

        user = User.new(user_params)

        if user.save
          render json: user, status: :created
        else
          render json: {error: user.errors.full_messages}, status: :unprocessable_entity
        end
      end
      
      private
    
      def user_params
        params.permit(:name, :username, :password)
      end

      def user_not_found
        user_exists = User.exists?(params[:id])
        if !user_exists
          render json: {message: "user not found"}, status: :not_found
        end
      end

    end
  end
end

