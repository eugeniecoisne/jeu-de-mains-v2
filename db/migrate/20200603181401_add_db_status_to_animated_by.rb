class AddDbStatusToAnimatedBy < ActiveRecord::Migration[6.0]
  def change
    add_column :animated_by, :db_status, :string
  end
end
