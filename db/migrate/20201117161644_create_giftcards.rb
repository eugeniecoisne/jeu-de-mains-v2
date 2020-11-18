class CreateGiftcards < ActiveRecord::Migration[6.0]
  def change
    create_table :giftcards do |t|
      t.float :amount
      t.string :code
      t.integer :buyer
      t.integer :receiver
      t.string :status
      t.boolean :db_status, default: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
