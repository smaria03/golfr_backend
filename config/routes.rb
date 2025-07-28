Rails.application.routes.draw do
  devise_for :users, skip: :all

  namespace :api do
    post 'login', to: 'users#login'
    get 'feed', to: 'scores#user_feed'

    resources :golfers, controller: 'users', only: [:show] do
      resources :scores, only: [:index]
    end

    resources :scores, only: %i[index create destroy]
  end
end
