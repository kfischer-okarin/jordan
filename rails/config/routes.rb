Rails.application.routes.draw do
  resources :videos, only: [] do
    put '/:youtube_id', to: 'videos#register', on: :collection, as: :register
  end
  resources :sessions, only: [:create]
end
