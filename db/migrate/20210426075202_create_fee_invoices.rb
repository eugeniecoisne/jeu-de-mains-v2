class CreateFeeInvoices < ActiveRecord::Migration[6.0]
  def change
    create_table :fee_invoices do |t|
      t.references :profile, null: false, foreign_key: true
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
