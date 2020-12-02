ActiveAdmin.register User, as: "Utilisateur" do
  menu priority: 2
  remove_filter :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at, :confirmation_token, :confirmation_sent_at, :uid
  permit_params :id, :first_name, :last_name, :email, :db_status, :confirmed_at, :provider, :unconfirmed_email,

  controller do
    def find_resource
      begin
        scoped_collection.where(slug: params[:id]).first!
      rescue ActiveRecord::RecordNotFound
        scoped_collection.find(params[:id])
      end
    end
  end

  index do
    selectable_column
    column :id
    column "Prénom", :first_name
    column "Nom", :last_name
    column "E-mail", :email
    column "Créé le", :created_at
    column "Confirmé le", :confirmed_at
    column "Modifié le", :updated_at
    column :unconfirmed_email
    column "Statut DB", :db_status
    column :provider
    column :admin
    column "Profil", :profile
    actions
  end

  # permit_params do
  #   permitted = [:email, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at, :db_status, :admin, :first_name, :last_name, :confirmation_token, :confirmed_at, :confirmation_sent_at, :unconfirmed_email, :provider, :uid]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

end
