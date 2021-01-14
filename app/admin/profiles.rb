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
    column "Profil partenaire" do |profile|
      if profile.role.present?
        link_to "Lien profil", "#{profile_public_path(profile)}", target: "_blank"
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
  end

  show :title => :company do
    attributes_table do
      row "Photo", :photo do |profile|
        if profile.photo.attached?
          cl_image_tag profile.photo.key, width: 100, height: 100, crop: :fill
        end
      end
      row :company
      row "Profil partenaire" do |profile|
        if profile.role.present?
          link_to "Lien profil", "#{profile_public_path(profile)}", target: "_blank"
        end
      end
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
        end
      end
    end

    organized_workshops = []

    User.find(profile.id).places.select { |place| place.workshops.present? }.each do |place|
      place.workshops.each do |workshop|
        organized_workshops << workshop
      end
    end

    if User.find(profile.id).places.select { |place| place.workshops.present? }.present?
      panel "Ateliers organisés" do
        table_for organized_workshops do
          column "ID Atelier" do |workshop|
            workshop.id
          end
          column "Atelier" do |workshop|
            link_to workshop.title, "#{admin_workshop_path(workshop)}"
          end
          column "Lieu" do |workshop|
            link_to workshop.place.name, "#{admin_place_path(workshop.place)}"
          end
          column "Ville" do |workshop|
            workshop.place.city
          end
          column "Créé le" do |workshop|
            workshop.created_at.strftime("%d/%m/%Y")
          end
          column :ephemeral
          column "Nb sessions en ligne" do |workshop|
            workshop.sessions.where(db_status: true).select { |s| s.date > Date.today }.count
          end
          column "Participants reçus" do |workshop|
            participants = 0
            Session.all.select { |s| s.workshop == workshop && s.date < Date.today }.each { |s| participants += s.sold }
            participants
          end
          column "Statut" do |workshop|
            workshop.status
          end
          column "Statut DB" do |workshop|
            workshop.db_status
          end
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
            animator.workshop.ephemeral
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

    if User.find(profile.id).animators.count > 0
      User.find(profile.id).animators.each do |animator|
        if animator.workshop.sessions.map { |s| s.bookings.each {|b| b.reviews}}.count > 0
          animator.workshop.sessions.map { |s| s.bookings.each {|b| b.reviews.each { |r| PROFILE_REVIEWS << r }}}
        end
      end
    end

    if User.find(profile.id).places.select { |p| p.workshops.present? }.map { |p| p.workshops }.count > 0
      User.find(profile.id).places.select { |p| p.workshops.present? }.map { |p| p.workshops }.each do |workshop|
        if workshop.sessions.map { |s| s.bookings.each {|b| b.reviews}}.count > 0
          workshop.sessions.map { |s| s.bookings.each {|b| b.reviews.each { |r| PROFILE_REVIEWS << r }}}
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
