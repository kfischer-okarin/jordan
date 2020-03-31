Rails.application.routes.draw do
  scope 'videos' do
    put '/:youtube_id', to: 'videos#register', as: :register
    post '/:youtube_id/annotations', to: 'annotations#create'
  end

  resources :annotations, only: [] do
    post '/publish', to: 'annotations#publish', on: :member
  end
  resources :sessions, only: [:create]
end
