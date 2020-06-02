class CreateProfiles < ActiveRecord::Migration[6.0]
  def change
    create_table :profiles do |t|
      t.string :last_name
      t.string :first_name
      t.string :address
      t.string :zip_code
      t.string :city
      t.string :phone_number
      t.string :role
      t.string :company
      t.string :siret_number
      t.string :website
      t.string :instagram
      t.text :description
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
