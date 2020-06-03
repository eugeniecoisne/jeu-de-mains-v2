class AddVerifiedToWorkshops < ActiveRecord::Migration[6.0]
  def change
    add_column :workshops, :verified, :boolean, default: false
  end
end
