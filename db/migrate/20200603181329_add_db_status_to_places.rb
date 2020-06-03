class AddDbStatusToPlaces < ActiveRecord::Migration[6.0]
  def change
    add_column :places, :db_status, :string
  end
end
