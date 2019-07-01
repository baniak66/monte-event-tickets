Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'

  get 'events/show/:id', to: 'events/show#show', as: 'events/show'
  post 'reservations/create', to: 'reservations/create#create', as: 'reservations/create'
  get 'reservations/show/:id', to: 'reservations/show#show', as: 'reservations/show'
end
