Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  get 'devenir_partenaire', to: 'pages#partners'
  get 'a_propos', to: 'pages#about'
  get 'contact', to: 'pages#contact'
  get 'mentions_legales', to: 'pages#legal_notice'
  get 'politique_de_confidentialite', to: 'pages#privacy_policy'
  get 'cgv', to: 'pages#cgv'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  devise_scope :user do
    match '/sessions/user', to: 'devise/sessions#create', via: :post
    match "/connexion", to: "devise/sessions#new", via: :get
    match "/inscription", to: "devise/registrations#new", via: :get
  end


  resources :profiles, :path => :membres, :as => :profiles, only: %i(show edit update) do
    resources :reviews, :path => :avis, :as => :reviews, only: %i(index)
    member do
      get 'tableau_de_bord'
      get 'messagerie'
    end
  end

  resources :profiles, :path => :animateurs, :as => :profiles, only: %i(index) do
    get 'public'
  end

  resources :places, :path => :lieux, :as => :places, except: %i(destroy) do
    resources :reviews, :path => :avis, :as => :reviews, only: %i(index)
  end

  resources :workshops, :path => :ateliers, :as => :workshops, except: %i() do
    resources :sessions, only: %i(new create index update)
    resources :animators, :path => :animateurs, :as => :animators, only: %i(new create)
    resources :reviews, :path => :avis, :as => :reviews, only: %i(index)
    member do
      get 'confirmation'
    end
  end

  resources :sessions, only: %i() do
    get 'search-places'
    get 'participants'
  end

  resources :sessions, only: %i(destroy)

  resources :bookings, :path => :reservations, :as => :bookings, only: %i(create destroy)

  resources :booking, :path => :reservations, :as => :bookings, only: %i() do
    resources :reviews, :path => :avis, :as => :reviews, only: %i(new create)
  end

  resources :animators, :path => :animateurs, :as => :animators, only: %i(edit update)

  resources :chatrooms, :path => :conversations, :as => :chatrooms, only: %i(show create update) do
    resources :messages, only: :create
  end

end
