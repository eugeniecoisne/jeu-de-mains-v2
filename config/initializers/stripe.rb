Rails.configuration.stripe = {
  publishable_key: ENV['STRIPE_CONNECT_PUBLIC_KEY'],
  secret_key: ENV['STRIPE_CONNECT_SECRET_KEY'],
  signing_secret: ENV['STRIPE_CLI_SIGNING_SECRET']
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
StripeEvent.signing_secret = Rails.configuration.stripe[:signing_secret]

StripeEvent.configure do |events|
  events.subscribe 'checkout.session.completed', StripeCheckoutSessionService.new
end
