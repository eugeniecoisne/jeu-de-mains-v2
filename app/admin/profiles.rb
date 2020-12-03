ActiveAdmin.register Profile do
  menu parent: "Comptes"
  actions :index, :show, :edit, :update

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
    actions
    column :id
    column :db_status
    column :user do |profile|
      link_to "#{profile.user.first_name} #{profile.user.last_name}", "#{admin_user_path(profile.user)}"
    end
    column :role
    column :company
    column :siret_number
    column :description do |profile|
      profile.description.present? ? true : false
    end
    column :city
    column :zip_code
    column :address
    column :website
    column :instagram
    column "Voir le profil", :slug do |profile|
      if profile.role == "animateur"
        link_to "Lien", "#{profile_public_path(profile)}", target: "_blank"
      end
    end
  end

  PROFILE_USERS = User.all.map { |u| ["#{u.first_name} #{u.last_name}", u.id] }.to_h

  form do |f|
    f.inputs "Utilisateur, nom d'entreprise et rôle" do
      f.input :user, collection: PROFILE_USERS
      f.input :company
      f.input :role, collection: ["animateur", "organisateur"]
    end
    f.inputs "Adresse" do
      f.input :address
      f.input :zip_code
      f.input :city
    end
    f.inputs "Coordonnées" do
      f.input :phone_number
      f.input :siret_number
      f.input :website
      f.input :instagram
    end
    f.inputs "Fiche" do
      f.input :description
      f.input :photo, as: :file, input_html: { accept: "image/*"}
    end
    f.inputs "Statut" do
      f.input :db_status, as: :boolean
    end
    f.actions
  end

  permit_params :address, :zip_code, :city, :phone_number, :role, :company, :siret_number, :website, :instagram, :description, :user_id, :user, :db_status, :slug, :photo

end
