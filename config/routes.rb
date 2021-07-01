Rails.application.routes.draw do

  get 'sitemaps/sitemap'
  get 'sitemap', to: 'sitemaps#sitemap'

  get 'fee_invoices/create'
  ActiveAdmin.routes(self)
  get 'giftcards/new'
  get 'giftcards/create'
  get 'giftcards/update'
  get 'giftcards/show'
  get 'infomessages/create'
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks', confirmations: 'users/confirmations', registrations: 'users/registrations' }
  root to: 'pages#home'
  get 'offrir-une-carte-cadeau', to: 'pages#offer_giftcard'
  get 'enregistrer-une-carte-cadeau', to: 'pages#register_giftcard'
  get 'devenir-partenaire', to: 'pages#become_partner'
  get 'bienvenue-partenaire', to: 'pages#welcome_partner'
  get 'entreprises', to: "pages#entreprises"
  get 'entreprises-message-envoye', to: 'pages#entreprises_sent'
  get 'a-propos', to: 'pages#about'
  get 'classement-des-annonces', to: 'pages#ranking'
  get 'nous-contacter', to: 'pages#contact'
  get 'message-envoye', to: 'pages#contact_us_sent'
  get 'mentions-legales', to: 'pages#legal_notice'
  get 'politique-de-confidentialite', to: 'pages#privacy_policy'
  get 'cgv', to: 'pages#cgv'
  get 'autour-du-fil', to: 'pages#autour_du_fil'
  get 'vegetal', to: 'pages#vegetal'
  get 'papier-et-calligraphie', to: 'pages#papier_et_calligraphie'
  get 'ceramique-et-modelage', to: 'pages#ceramique_et_modelage'
  get 'bijoux', to: 'pages#bijoux'
  get 'cosmetique-et-entretien', to: 'pages#cosmetique_et_entretien'
  get 'peinture-et-dessin', to: 'pages#peinture_et_dessin'
  get 'meuble-et-decoration', to: 'pages#meuble_et_decoration'
  get 'travail-du-cuir', to: 'pages#travail_du_cuir'

  devise_scope :user do
    match '/sessions/user', to: 'devise/sessions#create', via: :post
    match "/connexion", to: "devise/sessions#new", via: :get
    match "/deconnexion", to: "devise/sessions#destroy", via: :delete
    match "/inscription", to: "devise/registrations#new", via: :get
  end



  require "sidekiq/web"
  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  mount StripeEvent::Engine, at: '/stripe-webhooks'

  resources :profiles, :path => :membres, :as => :profiles, only: %i(show edit update) do
    resources :reviews, :path => :avis, :as => :reviews, only: %i(index)
    member do
      get 'tableau_de_bord'
      get 'transactions'
      get 'releve_de_commissions'
      get 'comptabilite_reservations'
      get 'comptabilite_cartes_cadeaux'
      get 'mes_cartes_cadeaux'
      get 'messagerie'
      get 'send_finalisation_partner_email'
      get 'social_media'
    end
  end

  resources :profiles, :path => :partenaires, :as => :profiles, only: %i(index) do
    get 'public'
  end

  resources :places, :path => :lieux, :as => :places, except: %i(show destroy index edit)

  resources :workshops, :path => :ateliers, :as => :workshops, except: %i() do
    resources :sessions, only: %i(new create index update)
    resources :animators, :path => :animateurs, :as => :animators, only: %i(new create)
    resources :reviews, :path => :avis, :as => :reviews, only: %i(index)
    member do
      get 'finalisation'
      get 'confirmation'
      get 'send_verification_mail'
      get 'mark_as_verified_or_unverified'
      get 'invitation'
      get 'privatisation'
      get 'privatisation_envoyee'
    end
  end

  resources :sessions, only: %i() do
    get 'search-places'
    get 'participants'
    get 'informations_visioconference', to: 'sessions#send_visio_information'
    get 'expedition_kits'
    get 'annulation'
  end

  resources :sessions, only: %i() do
    resources :infomessages, only: %i(new create)
  end

  resources :sessions, only: %i(destroy)

  resources :bookings, :path => :reservations, :as => :bookings, only: %i(create show update destroy)

  resources :bookings, :path => :reservations, :as => :bookings, only: %i() do
    resources :payments, only: :new
    resources :reviews, :path => :avis, :as => :reviews, only: %i(new create)
    get 'options'
    get 'coordonnees'
    get 'payment_success'
    get 'payment_error'
    get 'refund_invoice'
    get 'cancel'
    get 'report_or_refund'
    get 'admin_report_or_refund'
  end

  resources :reviews, :path => :avis, :as => :reviews, only: %i(destroy) do
    get 'report_review'
  end

  resources :fee_invoices, only: %i(create destroy)

  resources :animators, :path => :animateurs, :as => :animators, only: %i(edit update)

  resources :chatrooms, :path => :conversations, :as => :chatrooms, only: %i(show create update) do
    resources :messages, only: :create
  end

  resources :giftcards, :path => :carte_cadeau, :as => :giftcards, only: %i(new create update destroy)

  resources :giftcards, :path => :carte_cadeau, :as => :giftcards, only: %i() do
    resources :giftcard_payments, only: :new
    get 'confirmation_achat'
    get 'erreur_achat'
    get 'confirmation_enregistrement'
  end
end
