class AddCgvAgreementToGiftcards < ActiveRecord::Migration[6.0]
  def change
    add_column :giftcards, :cgv_agreement, :boolean, default: false
  end
end
