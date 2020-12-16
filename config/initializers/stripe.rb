Rails.configuration.stripe = {
  :publishable_key => ENV['STRIPE_CONNECT_PUBLIC_KEY'],
  :secret_key => ENV['STRIPE_CONNECT_SECRET_KEY']
}

Stripe.api_key = ENV['STRIPE_CONNECT_SECRET_KEY']
