class CreateAnimatedBy < ActiveRecord::Migration[6.0]
  def change
    create_table :animated_by do |t|
      t.references :user, null: false, foreign_key: true
      t.references :workshop, null: false, foreign_key: true

      t.timestamps
    end
  end
end
