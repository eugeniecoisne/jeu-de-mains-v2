class AddReadyAndAccountancyColumnsToProfiles < ActiveRecord::Migration[6.0]
  def change
    add_column :profiles, :ready, :boolean, default: false
    add_column :profiles, :accountant_company, :string
    add_column :profiles, :accountant_address, :string
    add_column :profiles, :accountant_zip_code, :string
    add_column :profiles, :accountant_city, :string
    add_column :profiles, :accountant_phone_number, :string
  end
end
