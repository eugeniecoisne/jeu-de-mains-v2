class AddKitShippingPriceAndPrivatizationToWorkshops < ActiveRecord::Migration[6.0]
  def change
    add_column :workshops, :kit_shipping_price, :float
    add_column :workshops, :privatization, :boolean, default: false
  end
end
