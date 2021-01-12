class RemoveFieldsFromPlaces < ActiveRecord::Migration[6.0]
  def change
    remove_column :places, :description
    remove_column :places, :email
    remove_column :places, :siret_number
    remove_column :places, :website
    remove_column :places, :instagram
    remove_column :places, :verified
    remove_column :places, :slug
  end
end
