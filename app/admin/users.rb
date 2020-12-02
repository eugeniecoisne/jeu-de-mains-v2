ActiveAdmin.register User do
  menu parent: "Comptes"
  remove_filter :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at, :confirmation_token, :confirmation_sent_at, :uid
  permit_params :id, :first_name, :last_name, :email, :password, :password_confirmation

  index do
    selectable_column
    actions
    column :id
    column :db_status
    column :profile
    column :first_name
    column :last_name
    column :email
    column :created_at
    column :confirmed_at
    column :updated_at
    column :unconfirmed_email
    column :provider
    column :admin
  end

  form do |f|
    f.inputs "Nom, prénom, e-mail" do
      f.input :last_name
      f.input :first_name
      f.input :email
    end
    f.inputs "Mot de Passe" do
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end
end
