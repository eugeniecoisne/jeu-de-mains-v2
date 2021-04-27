class AddLegalInformationsToProfiles < ActiveRecord::Migration[6.0]
  def change
    add_column :profiles, :tva_intra, :string
    add_column :profiles, :rcs_or_rm, :string
    add_column :profiles, :company_type, :string
    add_column :profiles, :company_capital, :string
  end
end
