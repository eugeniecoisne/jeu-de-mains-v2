ActiveAdmin.register User do
  remove_filter :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at, :confirmation_token, :confirmation_sent_at, :uid
  permit_params :id, :first_name, :last_name, :email, :password, :password_confirmation

  index do
    selectable_column
    actions
    column :id
    column :db_status
    column "Rôle" do |user|
      user.profile.role
    end
    column :profile do |user|
      if user.profile.company.present?
        link_to user.profile.company, "#{admin_profile_path(user.profile)}"
      else
        link_to "Profil #{user.profile.id}", "#{admin_profile_path(user.profile)}"
      end
    end
    column :first_name
    column :last_name
    column :email
    column :created_at
    column :confirmation_sent_at
    column :confirmed_at
    column :updated_at
    column :provider
    column :admin
  end

  csv do
    column :id
    column :db_status
    column :profile do |user|
      user.profile.company
    end
    column "Rôle" do |user|
      user.profile.role
    end
    column :first_name
    column :last_name
    column :email
    column :created_at
    column :confirmation_sent_at
    column :confirmed_at
    column :updated_at
    column :provider
    column :admin
  end

  show :title => :fullname do
    attributes_table do
      row :profile
      row "Rôle" do |user|
        user.profile.role
      end
      row :admin
      row :last_name
      row :first_name
      row :email
      row :db_status
      row :created_at
      row :confirmation_sent_at
      row :confirmed_at
      row :updated_at
      row :provider
    end
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
