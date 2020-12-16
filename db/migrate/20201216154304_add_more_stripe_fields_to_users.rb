class AddMoreStripeFieldsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :stripe_provider, :string
    add_column :users, :stripe_uid, :string
  end
end
