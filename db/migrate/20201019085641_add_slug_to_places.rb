class AddSlugToPlaces < ActiveRecord::Migration[6.0]
  def change
    add_column :places, :slug, :string
    add_index :places, :slug, unique: true
  end
end
