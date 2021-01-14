class AddEphemeralToWorkshops < ActiveRecord::Migration[6.0]
  def change
    add_column :workshops, :ephemeral, :boolean, default: false
  end
end
