module ApplicationHelper
  def stripe_url
    "https://connect.stripe.com/oauth/authorize?response_type=code&client_id=#{ENV['STRIPE_CONNECT_CLIENT_ID']}&scope=read_write"
  end

  def stripe_connect_button
    link_to stripe_url, class: "btn-stripe-connect" do
      content_tag :span, "Connecter à Stripe"
    end
  end
end
