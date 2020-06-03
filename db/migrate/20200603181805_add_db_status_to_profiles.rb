class AddDbStatusToProfiles < ActiveRecord::Migration[6.0]
  def change
    add_column :profiles, :db_status, :string
  end
end
