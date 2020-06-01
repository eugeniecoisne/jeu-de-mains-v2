class CreateSessions < ActiveRecord::Migration[6.0]
  def change
    create_table :sessions do |t|
      t.date :date
      t.string :start_at
      t.integer :capacity
      t.references :workshop, null: false, foreign_key: true

      t.timestamps
    end
  end
end
