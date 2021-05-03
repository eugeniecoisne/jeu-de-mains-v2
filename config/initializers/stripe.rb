Rails.configuration.stripe = {
  publishable_key: ENV['STRIPE_CONNECT_PUBLIC_KEY'],
  secret_key: ENV['STRIPE_CONNECT_SECRET_KEY'],
  signing_secret: ENV['STRIPE_CLI_SIGNING_SECRET']
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
Stripe.api_version = '2020-08-27'
StripeEvent.signing_secret = Rails.configuration.stripe[:signing_secret]

StripeEvent.configure do |events|
  events.subscribe 'checkout.session.completed' do |event|
    StripeCheckoutSessionService.new
  end
end

StripeEvent.configure do |events|
  events.subscribe 'charge.refunded' do |event|
    StripeRefundService.new
  end
end
