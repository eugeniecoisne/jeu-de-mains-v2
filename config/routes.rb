Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  get 'partners', to: 'pages#partners'
  get 'about', to: 'pages#about'
  get 'contact', to: 'pages#contact'
  get 'legal_notice', to: 'pages#legal_notice'
  get 'privacy_policy', to: 'pages#privacy_policy'
  get 'cgv', to: 'pages#cgv'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  devise_scope :user do
    match '/sessions/user', to: 'devise/sessions#create', via: :post
  end
  resources :profiles, only: %i(index show edit update) do
    resources :reviews, only: %i(index)
    member do
      get 'dashboard'
      get 'chat'
    end
    get 'public'
  end

  resources :places, except: %i(destroy) do
    resources :reviews, only: %i(index)
  end

  resources :workshops, except: %i() do
    resources :sessions, only: %i(new create index update)
    resources :animators, only: %i(new create)
    resources :reviews, only: %i(index)
    member do
      get 'confirmation'
    end
  end

  resources :sessions, only: %i() do
    get 'search-places'
    get 'participants'
  end

  resources :sessions, only: %i(destroy)

  resources :bookings, only: %i(create destroy)

  resources :booking, only: %i() do
    resources :reviews, only: %i(new create)
  end

  resources :animators, only: %i(edit update)

  resources :chatrooms, only: %i(show create update) do
    resources :messages, only: :create
  end

end
