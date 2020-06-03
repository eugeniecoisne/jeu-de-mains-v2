class AddDbStatusToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :db_status, :string
  end
end
