class RemoveFirstAndLastNamesFromProfiles < ActiveRecord::Migration[6.0]
  def change
    remove_column :profiles, :first_name
    remove_column :profiles, :last_name
  end
end
