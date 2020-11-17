class AddReasonToSessions < ActiveRecord::Migration[6.0]
  def change
    add_column :sessions, :reason, :string
  end
end
