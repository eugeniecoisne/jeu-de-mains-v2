ActiveAdmin.register Profile do

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
    column :user do |profile|
      link_to "#{profile.user.first_name} #{profile.user.last_name}", "#{admin_utilisateur_path(profile.user)}"
    end
    column "Statut DB", :db_status
    column "Rôle", :role
    column "Entreprise", :company
    column "SIRET", :siret_number
    column "Description", :description do |profile|
      if profile.description.present?
        "#{profile.description[0...50]}..."
      end
    end
    column "Ville", :city
    column "Code postal", :zip_code
    column "Adresse", :address
    column "site", :website
    column :instagram
    actions
  end
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :address, :zip_code, :city, :phone_number, :role, :company, :siret_number, :website, :instagram, :description, :user_id, :db_status, :slug
  #
  # or
  #
  # permit_params do
  #   permitted = [:last_name, :first_name, :address, :zip_code, :city, :phone_number, :role, :company, :siret_number, :website, :instagram, :description, :user_id, :db_status, :slug]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

end
