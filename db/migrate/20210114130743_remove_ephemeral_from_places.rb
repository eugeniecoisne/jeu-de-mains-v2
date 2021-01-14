class RemoveEphemeralFromPlaces < ActiveRecord::Migration[6.0]
  def change
    remove_column :places, :ephemeral
  end
end
