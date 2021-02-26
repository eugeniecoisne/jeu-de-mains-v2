class AddCguAgreementToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :cgu_agreement, :boolean, default: false
  end
end
