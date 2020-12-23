class CreateSessionProductAndPricesJob < ApplicationJob
  queue_as :default

  def perform(session)
    key = "#{ENV['STRIPE_CONNECT_SECRET_KEY']}"
    Stripe.api_key = key

    product = Stripe::Product.create({
      id: "prod_#{session.id}#{session.workshop.id}_jdm",
      name: "Atelier #{session.workshop.title} du #{session.date.strftime("%d/%m/%y")} à #{session.start_at}",
      unit_label: "place(s)",
      description: "#{session.workshop.program[0..150]}(...)",
      statement_descriptor: "#{session.workshop.place.name[0..30]}",
      images: [session.workshop.photos[0].service_url]
    })

    price = Stripe::Price.create({
      unit_amount: (session.workshop.price * 100).to_i,
      currency: 'eur',
      product: "prod_#{session.id}#{session.workshop.id}_jdm",
    })

    session.update(stripe_product_id: product.id, stripe_price_id: price.id)
  end
end
