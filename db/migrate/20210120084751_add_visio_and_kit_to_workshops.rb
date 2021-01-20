class AddVisioAndKitToWorkshops < ActiveRecord::Migration[6.0]
  def change
    add_column :workshops, :kit, :boolean, default: false
    add_column :workshops, :kit_description, :text
    add_column :workshops, :visio, :boolean, default: false
  end
end
