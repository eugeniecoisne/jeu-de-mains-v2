class AddEndTimeToSessions < ActiveRecord::Migration[6.0]
  def change
    add_column :sessions, :end_time, :string
    add_column :sessions, :end_date, :date
    rename_column :sessions, :date, :start_date
    rename_column :sessions, :start_at, :start_time
  end
end
