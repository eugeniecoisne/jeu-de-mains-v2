class CreateInfomessages < ActiveRecord::Migration[6.0]
  def change
    create_table :infomessages do |t|
      t.string :subjet
      t.text :content
      t.references :session, null: false, foreign_key: true

      t.timestamps
    end
  end
end
