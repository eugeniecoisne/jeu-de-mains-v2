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

  resources :profiles, only: %i(index show edit update) do
    resources :reviews, only: %i(index)
    member do
      get 'dashboard'
    end
    get 'public'
  end

  resources :places, except: %i(destroy) do
    resources :reviews, only: %i(index)
  end

  resources :workshops, except: %i(destroy) do
    resources :sessions, only: %i(new create index)
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

  resources :bookings, only: %i(create)

  resources :booking, only: %i() do
    resources :reviews, only: %i(new create)
  end

  resources :animators, only: %i(edit update)

end
