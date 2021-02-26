ActiveAdmin.register Workshop do
  menu parent: "Fiches"
  config.per_page = 50
  remove_filter :slug, :photos_attachments, :photos_blobs
  permit_params :title, :ephemeral, :thematic, :level, :duration, :capacity, :price, :program, :final_product, :recommendable, :verified, :status, :db_status, :slug, :place, :place_id, :kit, :kit_description, :visio, photos:[]

  action_item "Ajouter un animateur" do
    link_to("Ajouter un animateur", new_admin_animator_path, class: :button)
  end

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
    column :ephemeral
    column :place do |workshop|
      link_to workshop.place.name, "#{admin_place_path(workshop.place)}"
    end
    column "Organisateur" do |workshop|
      link_to workshop.place.user.profile.company, "#{admin_profile_path(workshop.place.user.profile)}"
    end
    column "Animateur" do |workshop|
      if workshop.animators.where(db_status: true).present?
        link_to workshop.animators.where(db_status: true).last.user.profile.company, "#{admin_profile_path(workshop.animators.where(db_status: true).last.user.profile)}"
      end
    end
    column "ID Animation" do |workshop|
      if workshop.animators.where(db_status: true).present?
        link_to workshop.animators.where(db_status: true).last.id, "#{admin_animator_path(workshop.animators.where(db_status: true).last)}"
      end
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
    column "Participants reçus" do |workshop|
      participants = 0
      Session.all.select { |s| s.workshop == workshop && s.date < Date.today }.each { |s| participants += s.sold }
      participants
    end
    column :created_at
    column :updated_at
    column "Voir page publique", :slug do |workshop|
      link_to "Lien", "#{workshop_path(workshop)}", target: "_blank"
    end
    column "Nb photos" do |workshop|
      workshop.photos.count
    end
    column "Photo 1" do |workshop|
      if workshop.photos.count > 0
        link_to "Lien 1", "#{cl_image_path workshop.photos[0].key}", target: "_blank"
      end
    end
    column "Photo 2" do |workshop|
      if workshop.photos.count > 1
        link_to "Lien 2", "#{cl_image_path workshop.photos[1].key}", target: "_blank"
      end
    end
    column "Photo 3" do |workshop|
      if workshop.photos.count > 2
        link_to "Lien 3", "#{cl_image_path workshop.photos[2].key}", target: "_blank"
      end
    end
    column "Photo 4" do |workshop|
      if workshop.photos.count > 3
        link_to "Lien 4", "#{cl_image_path workshop.photos[3].key}", target: "_blank"
      end
    end
    column "Photo 5" do |workshop|
      if workshop.photos.count > 4
        link_to "Lien 5", "#{cl_image_path workshop.photos[4].key}", target: "_blank"
      end
    end
    column "Photo 6" do |workshop|
      if workshop.photos.count > 5
        link_to "Lien 6", "#{cl_image_path workshop.photos[5].key}", target: "_blank"
      end
    end
    column "Photo 7" do |workshop|
      if workshop.photos.count > 6
        link_to "Lien 7", "#{cl_image_path workshop.photos[6].key}", target: "_blank"
      end
    end
    column "Photo 8" do |workshop|
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
    column :ephemeral
    column :place do |workshop|
      workshop.place.name
    end
    column "Organisateur" do |workshop|
      workshop.place.user.profile.company
    end
    column "Adresse postale" do |workshop|
      "#{workshop.place.address} #{workshop.place.zip_code} #{workshop.place.city}"
    end
    column "Ville" do |workshop|
      workshop.place.city
    end
    column "Animateur" do |workshop|
      if workshop.animators.where(db_status: true).present?
        workshop.animators.where(db_status: true).last.user.profile.company
      end
    end
    column "ID Animation" do |workshop|
      if workshop.animators.where(db_status: true).present?
        workshop.animators.where(db_status: true).last.id
      end
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
    column "Participants reçus" do |workshop|
      participants = 0
      Session.all.select { |s| s.workshop == workshop && s.date < Date.today }.each { |s| participants += s.sold }
      participants
    end
    column :created_at
    column :updated_at
    column :slug
    column "Nb photos" do |workshop|
      workshop.photos.count
    end
    column "Photo 1" do |workshop|
      "#{cl_image_path workshop.photos[0].key}" if workshop.photos.count > 0
    end
    column "Photo 2" do |workshop|
      "#{cl_image_path workshop.photos[1].key}" if workshop.photos.count > 1
    end
    column "Photo 3" do |workshop|
      "#{cl_image_path workshop.photos[2].key}" if workshop.photos.count > 2
    end
    column "Photo 4" do |workshop|
      "#{cl_image_path workshop.photos[3].key}" if workshop.photos.count > 3
    end
    column "Photo 5" do |workshop|
      "#{cl_image_path workshop.photos[4].key}" if workshop.photos.count > 4
    end
    column "Photo 6" do |workshop|
      "#{cl_image_path workshop.photos[5].key}" if workshop.photos.count > 5
    end
    column "Photo 7" do |workshop|
      "#{cl_image_path workshop.photos[6].key}" if workshop.photos.count > 6
    end
    column "Photo 8" do |workshop|
      "#{cl_image_path workshop.photos[7].key}" if workshop.photos.count > 7
    end
  end

  show do |workshop|
    attributes_table do
      row "Photo #1" do |workshop|
        if workshop.photos.attached?
          cl_image_tag workshop.photos[0].key, width: 100, height: 100, crop: :fill
        end
      end
      row :id
      row :title
      row :place
      row "Auteur" do |workshop|
        link_to "#{workshop.place.user.fullname} / #{workshop.place.user.profile.company}", "#{admin_profile_path(workshop.place.user.profile)}"
      end
      row "Ville" do |workshop|
        workshop.place.city
      end
      row "Animateur" do |workshop|
        if workshop.animators.where(db_status: true).present?
          link_to workshop.animators.where(db_status: true).last.user.profile.company, "#{admin_profile_path(workshop.animators.where(db_status: true).last.user.profile)}"
        end
      end
      row "ID Animation" do |workshop|
        if workshop.animators.where(db_status: true).present?
          link_to workshop.animators.where(db_status: true).last.id, "#{admin_animator_path(workshop.animators.where(db_status: true).last)}"
        end
      end
      row :program
      row :final_product
      row :thematic
      row :level
      row :duration
      row :capacity
      row :ephemeral
      row :price
      row :rating
      row "Nombre d'avis" do |workshop|
        Review.all.where(db_status: true).select { |r| r.booking.session.workshop == workshop }.count
      end
      row "Sessions en ligne" do |workshop|
        workshop.sessions.where(db_status: true).select { |s| s.date > Date.today }.count
      end
      row "Participants reçus" do |workshop|
        participants = 0
        Session.all.select { |s| s.workshop == workshop && s.date < Date.today }.each { |s| participants += s.sold }
        participants
      end
      row :recommendable
      row :created_at
      row :updated_at
      row :verified
      row :status
      row :db_status
      row :slug
      row "Voir page publique" do |workshop|
        link_to "Voir", "#{workshop_path(workshop)}", target: "_blank"
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
          column "Places vendues / en cours" do |session|
            session.capacity - session.available
          end
          column "Places restantes" do |session|
            session.available
          end
          column "À venir ?" do |session|
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
            link_to "#{review.user.fullname}", "#{admin_user_path(review.user)}"
          end
          column :created_at
          column :db_status
        end
      end
    end
  end

  form do |f|
    f.inputs :except => [:thematic, :level, :slug, :status]

    f.inputs "Filtres" do
      f.input :thematic, collection: Workshop::THEMATICS, input_html: { multiple: true}
      f.input :level, collection: Workshop::LEVELS
    end
    f.inputs "Statut (Mettre 'hors ligne' par défaut)" do
      f.input :status, collection:["en ligne", "hors ligne"]
    end
    f.inputs "Photos" do
      f.input :photos, as: :file, input_html: { multiple: true, accept: "image/*"}
    end
    f.actions
  end

end
