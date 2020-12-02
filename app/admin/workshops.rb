
ActiveAdmin.register Workshop do
  menu priority: 3
  remove_filter :slug, :photos_attachments, :photos_blobs
  permit_params :title, :thematic, :level, :duration, :capacity, :price, :program, :final_product, :recommendable, :verified, :status, :db_status, :slug

  # find record with slug(friendly_id)
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
    column "Titre", :title
    column "Lieu", :place do |workshop|
      workshop.place.name
    end
    column "Thème", :thematic
    column "Niveau", :level
    column "Durée", :duration
    column "Capacité", :capacity
    column "Prix", :price
    column "Programme", :program do |workshop|
      "#{workshop.program[0...50]}..."
    end
    column "Repartez avec", :final_product do |workshop|
      "#{workshop.final_product[0...50]}..."
    end
    column "Note JDM", :recommendable
    column "Vérifié?", :verified
    column "Status", :status
    column "Statut DB", :db_status
    column "URL", :slug do |workshop|
      link_to "#{workshop_path(workshop)}", "#{workshop_path(workshop)}"
    end
    column "Nb photos", :photos do |workshop|
      workshop.photos.count
    end
    column "Photo 1", :photos do |workshop|
      if workshop.photos.count > 0
        link_to "Lien 1", "#{cl_image_path workshop.photos[0].key}"
      end
    end
    column "Photo 2", :photos do |workshop|
      if workshop.photos.count > 1
        link_to "Lien 2", "#{cl_image_path workshop.photos[1].key}"
      end
    end
    column "Photo 3", :photos do |workshop|
      if workshop.photos.count > 2
        link_to "Lien 3", "#{cl_image_path workshop.photos[2].key}"
      end
    end
    column "Photo 4", :photos do |workshop|
      if workshop.photos.count > 3
        link_to "Lien 4", "#{cl_image_path workshop.photos[3].key}"
      end
    end
    column "Photo 5", :photos do |workshop|
      if workshop.photos.count > 4
        link_to "Lien 5", "#{cl_image_path workshop.photos[4].key}"
      end
    end
    column "Photo 6", :photos do |workshop|
      if workshop.photos.count > 5
        link_to "Lien 6", "#{cl_image_path workshop.photos[5].key}"
      end
    end
    column "Photo 7", :photos do |workshop|
      if workshop.photos.count > 6
        link_to "Lien 7", "#{cl_image_path workshop.photos[6].key}"
      end
    end
    column "Photo 8", :photos do |workshop|
      if workshop.photos.count > 7
        link_to "Lien 8", "#{cl_image_path workshop.photos[7].key}"
      end
    end
    actions
  end

  form do |f|
    f.inputs "Intitulé & lieu" do
      f.input :title, label: "Intitulé"
      f.input :place_id, label: "Lieu rattaché"
    end

    f.inputs "Filtres" do
      f.input :thematic, label: "Type d'atelier", collection: Workshop::THEMATICS
      f.input :level, label: "Niveau requis pour participer", collection: Workshop::LEVELS
      f.input :capacity, label: "Nombre de places proposées"
      f.input :duration, label: "Durée de l'atelier en minutes"
      f.input :price, label: "Prix par personne"
    end

    f.inputs "Programme" do
      f.input :program, label: "Programme"
      f.input :final_product, label: "Repartez avec"
    end

    f.inputs "Photos" do
      f.input :photos, as: :file, input_html: { multiple: true, accept: "image/*"}
    end
    f.actions
  end

  # permit_params do
  #   permitted = [:title, :program, :final_product, :thematic, :level, :duration, :price, :status, :capacity, :place_id, :db_status, :verified, :recommendable, :slug]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

end
