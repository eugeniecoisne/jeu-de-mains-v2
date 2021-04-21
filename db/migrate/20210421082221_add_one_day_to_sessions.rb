class AddOneDayToSessions < ActiveRecord::Migration[6.0]
  def change
    add_column :sessions, :one_day, :boolean, default: false
  end
end
