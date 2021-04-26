ActiveAdmin.register FeeInvoice do
  menu parent: "Financier"
  config.per_page = 50

  permit_params :profile_id, :profile, :start_date, :end_date
  FEE_INVOICE_PROFILES = Profile.all.select { |p| p.role.present? == true }.map { |p| ["#{p.company}", p.id] }.to_h

  index do
    selectable_column
    actions
    column :id
    column :profile
    column :start_date
    column :end_date
    column :created_at
    column :updated_at
  end

  csv do
    column :id
    column :profile
    column :start_date
    column :end_date
    column :created_at
    column :updated_at
  end

  show do |fee_invoice|
    attributes_table do
      row :id
      row :profile
      row :start_date
      row :end_date
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs "Entreprise" do
      f.input :profile, collection: FEE_INVOICE_PROFILES, value: :profile
    end
    f.inputs "Dates" do
      f.input :start_date
      f.input :end_date
    end
    f.actions
  end
end
