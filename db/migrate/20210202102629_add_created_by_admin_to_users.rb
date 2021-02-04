class AddCreatedByAdminToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :created_by_admin, :boolean, default: false
  end
end
