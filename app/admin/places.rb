ActiveAdmin.register Place do
  menu priority: 4
  remove_filter :slug, :photo_attachment, :photo_blob

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
    column "Statut DB", :db_status
    column "Vérifié?", :verified
    column "Nom", :name
    column "Ville", :city
    column "Code postal", :zip_code
    column "Adresse", :address
    column "Description", :description do |place|
      "#{place.description[0...50]}..."
    end
    column "N° tél", :phone_number
    column "E-mail", :email
    column "Éphémère?", :ephemeral
    column "SIRET", :siret_number
    column "site", :website
    column :instagram
    column :user do |place|
      "#{place.user.first_name} #{place.user.last_name}"
    end
    column "URL", :slug do |place|
      link_to "#{place_path(place)}", "#{place_path(place)}"
    end
    column "Photo", :photo do |place|
      link_to "Lien", "#{cl_image_path place.photo.key}"
    end
    actions
  end



  permit_params :name, :address, :zip_code, :city, :description, :phone_number, :email, :ephemeral, :siret_number, :website, :instagram, :user_id, :db_status, :verified, :latitude, :longitude, :slug
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :address, :zip_code, :city, :description, :phone_number, :email, :ephemeral, :siret_number, :website, :instagram, :user_id, :db_status, :verified, :latitude, :longitude, :slug]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

end
