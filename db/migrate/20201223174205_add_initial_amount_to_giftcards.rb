class AddInitialAmountToGiftcards < ActiveRecord::Migration[6.0]
  def change
    add_column :giftcards, :initial_amount, :float
  end
end
