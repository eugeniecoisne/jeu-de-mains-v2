class ChangeDbStatusToBeBooleanInUsers < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :db_status, :boolean, using: 'db_status::boolean', default: true
  end
end
