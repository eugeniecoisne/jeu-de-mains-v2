class CreatePlaces < ActiveRecord::Migration[6.0]
  def change
    create_table :places do |t|
      t.string :name
      t.string :address
      t.string :zip_code
      t.string :city
      t.text :description
      t.string :phone_number
      t.string :email
      t.boolean :ephemeral, default: false
      t.string :siret_number
      t.string :website
      t.string :instagram
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
