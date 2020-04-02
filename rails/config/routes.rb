Rails.application.routes.draw do
  scope 'videos' do
    put '/:youtube_id', to: 'videos#register', as: :register
    get '/:youtube_id/annotations', to: 'annotations#index'
    post '/:youtube_id/annotations', to: 'annotations#create'
  end

  resources :annotations, only: [:destroy] do
    post '/publish', to: 'annotations#publish', on: :member
  end
  resources :sessions, only: [:create]
end
