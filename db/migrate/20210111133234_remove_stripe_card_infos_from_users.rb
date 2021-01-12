class RemoveStripeCardInfosFromUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :card_last4
    remove_column :users, :card_exp_month
    remove_column :users, :card_exp_year
    remove_column :users, :card_type
  end
end
