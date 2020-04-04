Rails.application.routes.draw do
  resources :videos, only: %i[index]
  scope 'videos' do
    get '/:youtube_id', to: 'videos#show'
    put '/:youtube_id', to: 'videos#register', as: :register
    patch '/:youtube_id', to: 'videos#update'
    get '/:youtube_id/annotations', to: 'annotations#index'
    post '/:youtube_id/annotations', to: 'annotations#create'
    put '/:youtube_id/annotations/order', to: 'annotations#reorder'
  end

  resources :annotations, only: %i[update destroy] do
    post '/publish', to: 'annotations#publish', on: :member
  end
  resources :sessions, only: [:create]
  get '/passage', to: 'passages#show'
end
