class ChangeDbStatusToBeBooleanInWorkshops < ActiveRecord::Migration[6.0]
  def change
    change_column :workshops, :db_status, :boolean, using: 'db_status::boolean', default: true
  end
end
