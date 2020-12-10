ActiveAdmin.register Profile do
  menu parent: "Fiches"
  config.per_page = 50
  PROFILE_USERS = User.all.map { |u| ["#{u.first_name} #{u.last_name}", u.id] }.to_h


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
      link_to "#{profile.user.fullname}", "#{admin_user_path(profile.user)}"
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
    column :photo do |profile|
      if profile.photo.attached?
        link_to "Lien photo", "#{cl_image_path profile.photo.key}", target: "_blank"
      end
    end
    column "Profil animateur" do |profile|
      if profile.role == "animateur"
        link_to "Lien profil", "#{profile_public_path(profile)}", target: "_blank"
      end
    end
    column "Nombre de lieux" do |profile|
      profile.user.places.count
    end
    column "Lieu 1" do |profile|
      if profile.user.places.present?
        link_to "Lieu 1", "#{admin_place_path(profile.user.places[0])}"
      end
    end
    column "Lieu 2" do |profile|
      if profile.user.places.present? && profile.user.places.count > 1
        link_to "Lieu 2", "#{admin_place_path(profile.user.places[1])}"
      end
    end
    column "Lieu 3" do |profile|
      if profile.user.places.present? && profile.user.places.count > 2
        link_to "Lieu 3", "#{admin_place_path(profile.user.places[2])}"
      end
    end
    column "Lieu 4" do |profile|
      if profile.user.places.present? && profile.user.places.count > 3
        link_to "Lieu 4", "#{admin_place_path(profile.user.places[3])}"
      end
    end
  end

  # CSV

  csv do
    column :id
    column :db_status
    column "Prénom" do |profile|
      profile.user.first_name
    end
    column "Nom" do |profile|
      profile.user.last_name
    end
    column :role
    column :company
    column :siret_number
    column :description
    column :city
    column :zip_code
    column :address
    column :website
    column :instagram
    column :photo do |profile|
      if profile.photo.attached?
        cl_image_path profile.photo.key
      end
    end
    column "Nombre de lieux" do |profile|
      profile.user.places.count
    end
    column "Lieu 1" do |profile|
      if profile.user.places.present?
        profile.user.places[0].name
      end
    end
    column "Lieu 2" do |profile|
      if profile.user.places.present? && profile.user.places.count > 1
        profile.user.places[1].name
      end
    end
    column "Lieu 3" do |profile|
      if profile.user.places.present? && profile.user.places.count > 2
        profile.user.places[2].name
      end
    end
    column "Lieu 4" do |profile|
      if profile.user.places.present? && profile.user.places.count > 3
        profile.user.places[3].name
      end
    end
  end

  show :title => :company do
    attributes_table do
      row "Photo", :photo do |profile|
        if profile.photo.attached?
          cl_image_tag profile.photo.key, width: 100, height: 100, crop: :fill
        end
      end
      row :company
      row :role
      row :user do |profile|
        link_to profile.user.fullname, "#{admin_user_path(profile.user)}"
      end
      row :address
      row :zip_code
      row :city
      row :phone_number
      row :siret_number
      row :website
      row :instagram
      row :description
      row :db_status
      row :created_at
      row :updated_at
      row :slug
      row "Nombre de lieux" do |profile|
        profile.user.places.count
      end
    end

    if profile.user.places.present?
      panel "Lieux" do
        table_for profile.user.places do
          column :name do |place|
            link_to place.name, "#{admin_place_path(place)}"
          end
          column :created_at do |place|
            place.created_at.strftime('%d/%m/%Y')
          end
          column :city
          column :db_status
          column :verified
        end
      end
    end

    if User.find(profile.id).animators.present?
      panel "Ateliers animés" do
        table_for User.find(profile.id).animators do
          column "ID Atelier" do |animator|
            animator.workshop.id
          end
          column "Atelier" do |animator|
            link_to animator.workshop.title, "#{admin_workshop_path(animator.workshop)}"
          end
          column "Lieu" do |animator|
            link_to animator.workshop.place.name, "#{admin_place_path(animator.workshop.place)}"
          end
          column "Ville" do |animator|
            animator.workshop.place.city
          end
          column "Créé le" do |animator|
            animator.workshop.created_at.strftime("%d/%m/%Y")
          end
          column "Éphémère ?" do |animator|
            animator.workshop.place.ephemeral
          end
          column "Nb sessions en ligne" do |animator|
            animator.workshop.sessions.where(db_status: true).select { |s| s.date > Date.today }.count
          end
          column "Participants reçus" do |animator|
            participants = 0
            Session.all.select { |s| s.workshop == animator.workshop && s.date < Date.today }.each { |s| participants += s.sold }
            participants
          end
          column "Statut" do |animator|
            animator.workshop.status
          end
          column "Statut DB" do |animator|
            animator.workshop.db_status
          end
        end
      end
    end

    PROFILE_REVIEWS = []

    User.find(profile.id).animators.each do |animator|
      if animator.workshop.reviews.present?
        animator.workshop.reviews.each do |review|
          PROFILE_REVIEWS << review
        end
      end
    end

    if PROFILE_REVIEWS.count > 0
      panel "Avis animateur" do
        table_for PROFILE_REVIEWS do
          column "Avis" do |review|
            link_to "Avis ##{review.id}", "#{admin_review_path(review)}"
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
