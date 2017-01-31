Rails.application.routes.draw do

  get 'auth/login'
  get 'auth/logout'
  get 'auth/callback'

  get 'commits/index'

  get 'home/index'

  root 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
