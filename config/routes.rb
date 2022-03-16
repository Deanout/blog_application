Rails.application.routes.draw do
  authenticated :user, ->(user) { user.admin? } do
    get 'admin', to: 'admin#index'
    get 'admin/posts'
    get 'admin/comments'
    get 'admin/users'
    get 'admin/post/:id', to: 'admin#show_post', as: 'admin_post'
  end

  get 'search', to: 'search#index'

  get 'users/profile'
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  get '/u/:id', to: 'users#profile', as: 'user'

  # /posts/1/comments/4
  resources :posts do
    resources :comments
  end

  get 'about', to: 'pages#about'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'pages#home'
end
