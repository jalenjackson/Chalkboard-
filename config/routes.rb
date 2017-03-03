Rails.application.routes.draw do

  get '/user/:id' => 'pins#profile'

  devise_for :users

  resources :chatrooms do
    resource :chatroom_users
    resources :messages
  end


  resources :pins do
    resources :comments
    member do
      put "like", to: "pins#upvote"
    end

  end


  root 'pins#index'
  get '/chatrooms', to: 'chatrooms#index'





end
