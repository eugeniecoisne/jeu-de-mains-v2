class AddDbStatusToWorkshops < ActiveRecord::Migration[6.0]
  def change
    add_column :workshops, :db_status, :string
  end
end
