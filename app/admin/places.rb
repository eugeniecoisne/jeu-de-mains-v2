ActiveAdmin.register Place do
  remove_filter :slug, :photo_attachment, :photo_blob, :latitude, :longitude
  preserve_default_filters!
  PLACE_USERS = User.all.select { |u| u.profile.company.present? == true }.map { |u| [u.profile.company, u.id] }.to_h


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
    column :verified
    column :name
    column :city
    column :zip_code
    column :address
    column :description do |place|
      place.description.present? ? true : false
    end
    column :phone_number
    column :email
    column :ephemeral
    column :siret_number
    column :website
    column :instagram
    column :user do |place|
      "#{place.user.first_name} #{place.user.last_name}"
    end
    column "Voir la page", :slug do |place|
      link_to "Lien page", "#{place_path(place)}", target: "_blank"
    end
    column "Photo", :photo do |place|
      link_to "Lien photo", "#{cl_image_path place.photo.key}", target: "_blank"
    end
  end

  form do |f|
    f.inputs "Propriétaire et nom du lieu" do
      f.input :user, collection: PLACE_USERS
      f.input :name
    end
    f.inputs "Adresse" do
      f.input :address
      f.input :zip_code
      f.input :city
      f.input :ephemeral, as: :boolean
    end
    f.inputs "Coordonnées" do
      f.input :phone_number
      f.input :email
      f.input :siret_number
      f.input :website
      f.input :instagram
    end
    f.inputs "Fiche" do
      f.input :description
      f.input :photo, as: :file, input_html: { accept: "image/*"}
    end
    f.inputs "Statuts" do
      f.input :verified, as: :boolean
      f.input :db_status, as: :boolean
    end
    f.actions
  end


  permit_params :name, :address, :zip_code, :city, :description, :phone_number, :email, :ephemeral, :siret_number, :website, :instagram, :user, :user_id, :db_status, :verified, :latitude, :longitude, :slug, :photo

end
