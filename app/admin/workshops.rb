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
    column :thematic
    column :place do |workshop|
     link_to "#{workshop.place.name}", "#{admin_place_path(workshop.place)}"
    end
    column "Ville" do |workshop|
      workshop.place.city
    end
    column :level
    column :duration
    column :capacity
    column :price
    column :rating
    column "Nombre d'avis" do |workshop|
      Review.all.where(db_status: true).select { |r| r.booking.session.workshop == workshop }.count
    end
    column :recommendable
    column :program do |workshop|
      workshop.program.present? ? true : false
    end
    column :final_product do |workshop|
      workshop.final_product.present? ? true : false
    end
    column "Sessions en ligne" do |workshop|
      workshop.sessions.where(db_status: true).select { |s| s.date > Date.today }.count
    end
    column :created_at
    column :updated_at
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

  csv do
    column :id
    column :verified
    column :status
    column :db_status
    column :title
    column :thematic
    column :place do |workshop|
      workshop.place.name
    end
    column "Adresse postale" do |workshop|
      "#{workshop.place.address} #{workshop.place.zip_code} #{workshop.place.city}"
    end
    column "Ville" do |workshop|
      workshop.place.city
    end
    column :level
    column :duration
    column :capacity
    column :price
    column :rating
    column "Nombre d'avis" do |workshop|
      Review.all.where(db_status: true).select { |r| r.booking.session.workshop == workshop }.count
    end
    column :recommendable
    column :program do |workshop|
      workshop.program
    end
    column :final_product do |workshop|
      workshop.final_product
    end
    column "Sessions en ligne" do |workshop|
      workshop.sessions.where(db_status: true).select { |s| s.date > Date.today }.count
    end
    column :created_at
    column :updated_at
    column "Nb photos" do |workshop|
      workshop.photos.count
    end
    column :slug
  end

  show do |workshop|
    attributes_table do
      row "Photo #1" do |workshop|
        if workshop.photos.attached?
          cl_image_tag workshop.photos[0].key, width: 100, height: 100, crop: :fill
        end
      end
      row :title
      row :place
      row "Ville" do |workshop|
        workshop.place.city
      end
      row :program
      row :final_product
      row :thematic
      row :level
      row :duration
      row :capacity
      row :price
      row :rating
      row "Nombre d'avis" do |workshop|
        Review.all.where(db_status: true).select { |r| r.booking.session.workshop == workshop }.count
      end
      row "Sessions en ligne" do |workshop|
        workshop.sessions.where(db_status: true).select { |s| s.date > Date.today }.count
      end
      row :recommendable
      row :created_at
      row :updated_at
      row :verified
      row :db_status
      row :slug
      row "Voir page publique" do |workshop|
        link_to "Voir", "#{workshop_path(workshop)}"
      end
    end

    WORKSHOP_REVIEWS = Review.all.where(db_status: true).select { |r| r.booking.session.workshop == workshop }.sort_by { |r| r.created_at }

    if workshop.sessions.present?
      panel "Sessions" do
        table_for workshop.sessions.sort_by { |session| session.date } do
          column "Session" do |session|
            link_to "Voir", "#{admin_session_path(session)}"
          end
          column "Date" do |session|
            session.date.strftime("%d/%m/%Y")
          end
          column :start_at
          column :capacity
          column "Places restantes" do |session|
            session.available
          end
          column "En ligne ?" do |session|
            session.date > Date.today ? true : false
          end
          column :db_status
        end
      end
    end
    if WORKSHOP_REVIEWS.size > 0
      panel "Avis" do
        table_for WORKSHOP_REVIEWS do
          column "Avis" do |review|
            link_to "Voir", "#{admin_review_path(review)}"
          end
          column :rating
          column "Contenu" do |review|
            review.content[0..40]...
          end
          column "Auteur" do |review|
            link_to "#{review.user.first_name} #{review.user.last_name}", "#{admin_user_path(review.user)}"
          end
          column :created_at
          column :db_status
        end
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
