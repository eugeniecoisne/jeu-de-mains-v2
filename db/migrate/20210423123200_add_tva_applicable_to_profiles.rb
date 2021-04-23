class AddTvaApplicableToProfiles < ActiveRecord::Migration[6.0]
  def change
    add_column :profiles, :tva_applicable, :boolean, default: false
  end
end
