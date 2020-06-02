class CreateWorkshops < ActiveRecord::Migration[6.0]
  def change
    create_table :workshops do |t|
      t.string :title
      t.text :program
      t.text :final_product
      t.string :thematic
      t.string :level
      t.integer :duration
      t.float :price, default: 0, null: false
      t.string :status
      t.integer :capacity
      t.references :place, null: false, foreign_key: true

      t.timestamps
    end
  end
end
