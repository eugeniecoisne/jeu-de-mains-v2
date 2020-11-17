class AddColumnsToGiftcards < ActiveRecord::Migration[6.0]
  def change
    add_column :giftcards, :receiver_name, :string
    add_column :giftcards, :buyer_name, :string
    add_column :giftcards, :message, :string
  end
end
