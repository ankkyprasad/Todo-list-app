Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :api do
    namespace :v1 do
      jsonapi_resources :users, only: %i[index show destroy] do
        collection do
          post :register
          post :login
        end
      end
      jsonapi_resources :tasks
      # post '/user/register', to: 'users#register'
      # post '/user/login', to: 'users#login'
    end
  end

end
