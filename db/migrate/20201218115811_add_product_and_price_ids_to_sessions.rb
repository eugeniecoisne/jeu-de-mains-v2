class AddProductAndPriceIdsToSessions < ActiveRecord::Migration[6.0]
  def change
    add_column :sessions, :stripe_product_id, :string
    add_column :sessions, :stripe_price_id, :string
  end
end
