ActiveAdmin.register Workshop do
  remove_filter :slug, :photos_attachments, :photos_blobs
  permit_params :title, :thematic, :level, :duration, :capacity, :price, :program, :final_product, :recommendable, :verified, :status, :db_status, :slug, :place, :place_id, photos:[]
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
    actions
    column :id
    column :verified
    column :status
    column :db_status
    column :title
    column :place do |workshop|
      workshop.place.name
    end
    column :thematic
    column :level
    column :duration
    column :capacity
    column :price
    column :program do |workshop|
      workshop.program.present? ? true : false
    end
    column :final_product do |workshop|
      workshop.final_product.present? ? true : false
    end
    column :recommendable
    column "Voir la page", :slug do |workshop|
      link_to "Lien", "#{workshop_path(workshop)}", target: "_blank"
    end
    column "Nb photos", :photos do |workshop|
      workshop.photos.count
    end
    column "Photo 1", :photos do |workshop|
      if workshop.photos.count > 0
        link_to "Lien 1", "#{cl_image_path workshop.photos[0].key}", target: "_blank"
      end
    end
    column "Photo 2", :photos do |workshop|
      if workshop.photos.count > 1
        link_to "Lien 2", "#{cl_image_path workshop.photos[1].key}", target: "_blank"
      end
    end
    column "Photo 3", :photos do |workshop|
      if workshop.photos.count > 2
        link_to "Lien 3", "#{cl_image_path workshop.photos[2].key}", target: "_blank"
      end
    end
    column "Photo 4", :photos do |workshop|
      if workshop.photos.count > 3
        link_to "Lien 4", "#{cl_image_path workshop.photos[3].key}", target: "_blank"
      end
    end
    column "Photo 5", :photos do |workshop|
      if workshop.photos.count > 4
        link_to "Lien 5", "#{cl_image_path workshop.photos[4].key}", target: "_blank"
      end
    end
    column "Photo 6", :photos do |workshop|
      if workshop.photos.count > 5
        link_to "Lien 6", "#{cl_image_path workshop.photos[5].key}", target: "_blank"
      end
    end
    column "Photo 7", :photos do |workshop|
      if workshop.photos.count > 6
        link_to "Lien 7", "#{cl_image_path workshop.photos[6].key}", target: "_blank"
      end
    end
    column "Photo 8", :photos do |workshop|
      if workshop.photos.count > 7
        link_to "Lien 8", "#{cl_image_path workshop.photos[7].key}", target: "_blank"
      end
    end
  end

  form do |f|
    f.inputs :except => [:thematic, :level, :slug]

    f.inputs "Filtres" do
      f.input :thematic, collection: Workshop::THEMATICS
      f.input :level, collection: Workshop::LEVELS
    end
    f.inputs "Photos" do
      f.input :photos, as: :file, input_html: { multiple: true, accept: "image/*"}
    end
    f.actions
  end

end
