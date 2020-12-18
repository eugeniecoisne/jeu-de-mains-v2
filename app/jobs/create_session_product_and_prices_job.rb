class CreateSessionProductAndPricesJob < ApplicationJob
  queue_as :default

  def perform(session)
    key = session.workshop.place.user.access_code
    Stripe.api_key = key

    product = Stripe::Product.create({
      id: "prod_#{session.id}#{session.workshop.id}_jdm",
      name: "atelier-#{session.workshop.title.parameterize}-du-#{session.date.strftime("%d-%m-%y")}-a-#{session.start_at}",
      unit_label: "place(s)",
      description: "#{session.workshop.program[0..150]}(...)",
      statement_descriptor: "#{session.workshop.place.name.parameterize[0..30]}",
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
