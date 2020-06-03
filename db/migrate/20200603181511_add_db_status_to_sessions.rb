class AddDbStatusToSessions < ActiveRecord::Migration[6.0]
  def change
    add_column :sessions, :db_status, :string
  end
end
