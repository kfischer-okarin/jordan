Rails.application.routes.draw do
  scope 'videos' do
    get '/:youtube_id', to: 'videos#show'
    put '/:youtube_id', to: 'videos#register', as: :register
    patch '/:youtube_id', to: 'videos#update'
    get '/:youtube_id/annotations', to: 'annotations#index'
    post '/:youtube_id/annotations', to: 'annotations#create'
    put '/:youtube_id/annotations/order', to: 'annotations#reorder'
  end

  resources :annotations, only: [:destroy] do
    post '/publish', to: 'annotations#publish', on: :member
  end
  resources :sessions, only: [:create]
end
