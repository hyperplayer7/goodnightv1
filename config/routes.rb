Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :api do
    namespace :v1 do
      resources :sleeps, only: [:create] do
        member do
          post :follow
          delete :unfollow
          get :sleep_records
        end
      end
    end
  end
end
