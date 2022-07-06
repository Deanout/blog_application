Rails.application.routes.draw do
  resources :projects
  patch 'drag/project'
  get 'members/dashboard'
  resources :categories
  authenticated :user, ->(user) { user.admin? } do
    get 'admin', to: 'admin#index'
    get 'admin/posts'
    get 'admin/comments'
    get 'admin/users'
    get 'admin/post/:id', to: 'admin#show_post', as: 'admin_post'
  end

  get 'checkout', to: 'checkouts#show'
  get 'checkout/success', to: 'checkouts#success'
  get 'billing', to: 'billing#show'

  get 'search', to: 'search#index'

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  get '/u/:id', to: 'users#profile', as: 'user'
  resources :after_signup

  # /posts/1/comments/4
  resources :posts do
    resources :comments
  end

  get 'about', to: 'pages#about'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'pages#home'
end
