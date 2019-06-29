Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'

  namespace :events do
    resources :show, only: [:show]
  end
end
