ActiveAdmin.register Profile do
  menu parent: "Fiches"
  config.per_page = 50
  permit_params :address, :zip_code, :city, :phone_number, :role, :company, :siret_number, :website, :instagram, :description, :user_id, :user, :db_status, :slug, :ready, :accountant_company, :accountant_address, :accountant_zip_code, :accountant_city, :accountant_phone_number, :fee, :legal_mention, :tva_applicable, :tva_intra, :company_type, :company_capital, :rcs_or_rm, :photo
  PROFILE_USERS = User.all.map { |u| ["#{u.first_name} #{u.last_name} #{u.id}", u.id] }.to_h

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
    column :ready
    column :fee
    column :user do |profile|
      link_to "#{profile.user.fullname}", "#{admin_user_path(profile.user)}"
    end
    column :role
    column :company
    column :siret_number
    column :tva_applicable
    column :description do |profile|
      profile.description.present? ? true : false
    end
    column :address
    column :zip_code
    column :city
    column :phone_number
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
    column :accountant_company
    column :accountant_address
    column :accountant_zip_code
    column :accountant_city
    column :accountant_phone_number
    column :legal_mention
    column :tva_intra
    column :rcs_or_rm
    column :company_type
    column :company_capital
  end

  # CSV

  csv do
    column :id
    column :db_status
    column :ready
    column :fee
    column "Prénom" do |profile|
      profile.user.first_name
    end
    column "Nom" do |profile|
      profile.user.last_name
    end
    column :role
    column :company
    column :siret_number
    column :tva_applicable
    column :description
    column :address
    column :zip_code
    column :city
    column :phone_number
    column :website
    column :instagram
    column :photo do |profile|
      if profile.photo.attached?
        cl_image_path profile.photo.key
      end
    end
    column :accountant_company
    column :accountant_address
    column :accountant_zip_code
    column :accountant_city
    column :accountant_phone_number
    column :legal_mention
    column :tva_intra
    column :rcs_or_rm
    column :company_type
    column :company_capital
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
      row :id
      row :role
      row :fee
      row :user do |profile|
        link_to profile.user.fullname, "#{admin_user_path(profile.user)}"
      end
      row :address
      row :zip_code
      row :city
      row :phone_number
      row :siret_number
      row :tva_applicable
      row :accountant_company
      row :accountant_address
      row :accountant_zip_code
      row :accountant_city
      row :accountant_phone_number
      row :website
      row :instagram
      row :description
      row :db_status
      row :ready
      row :created_at
      row :updated_at
      row :slug
      row :legal_mention
      row :tva_intra
      row :rcs_or_rm
      row :company_type
      row :company_capital
      row "Envoyer e-mail demande de derniers docs partenaire" do
        link_to "Envoyer e-mail demande de derniers docs partenaire", "#{send_finalisation_partner_email_profile_path(profile)}", target: "_blank"
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
            workshop.sessions.where(db_status: true).select { |s| s.start_date > Date.today }.count
          end
          column "Participants reçus" do |workshop|
            participants = 0
            Session.all.select { |s| s.workshop == workshop && s.start_date < Date.today }.each { |s| participants += s.sold }
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
            animator.workshop.sessions.where(db_status: true).select { |s| s.start_date > Date.today }.count
          end
          column "Participants reçus" do |animator|
            participants = 0
            Session.all.select { |s| s.workshop == animator.workshop && s.start_date < Date.today }.each { |s| participants += s.sold }
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
      User.find(profile.id).places.select { |p| p.workshops.present? }.each do |place|
        if place.workshops.present?
          place.workshops.each do |workshop|
            if workshop.sessions.present? && workshop.sessions.map { |s| s.bookings.each {|b| b.reviews}}.count > 0
              workshop.sessions.map { |s| s.bookings.each {|b| b.reviews.each { |r| PROFILE_REVIEWS << r }}}
            end
          end
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
    f.inputs "Utilisateur, infos légales d'entreprise et rôle" do
      f.input :user, collection: PROFILE_USERS, value: :user
      f.input :company, hint: "Nom de la société affiché sur la plateforme"
      f.input :accountant_company, hint: "Nom de la société telle qu'écrite sur le KBIS"
      f.input :siret_number
      f.input :tva_applicable, hint: "Vérifier si le partenaire est redevable de la TVA ou exonéré"
      f.input :tva_intra, hint: "Ne remplir que si la case précédente est cochée"
      f.input :company_type, hint: "SAS, SARL, EURL, etc - Ne remplir que si c'est une société (pas auto entrepreneur ou entreprise individuelle)"
      f.input :company_capital, hint: "Exemple : 1.000 €, bien indiquer points entre milliers et le symbole €"
      f.input :rcs_or_rm, hint: "Format d'écriture : RCS [Ville] [Numéro] ou RM [Ville] [Numéro]"
      f.input :role, collection: Profile::ROLES, value: :role
    end
    f.inputs "Adresse & coordonnées comptables" do
      f.input :accountant_address
      f.input :accountant_zip_code
      f.input :accountant_city
      f.input :accountant_phone_number, hint: "Numéro uniquement utilisé avec Jeu de Mains"
    end
    f.inputs "Adresse & coordonnées publiques" do
      f.input :address
      f.input :zip_code
      f.input :city
      f.input :phone_number, hint: "Numéro affiché publiquement"
    end
    f.inputs "Sites web" do
      f.input :website
      f.input :instagram
    end
    f.inputs "Fiche" do
      f.input :description
      f.input :photo, as: :file, input_html: { accept: "image/*"}
    end
    f.inputs "Commission" do
      f.input :fee, hint: "Commission négociée dans le contrat : sous forme 0.X"
    end
    f.inputs "Statut" do
      f.input :db_status, as: :boolean
      f.input :ready, as: :boolean, hint: "Prêt à être mis en ligne, à cocher une fois tout le profil intégralement complété"
    end
    f.inputs "Mention légale page partenaire" do
      f.input :legal_mention, hint: "Exemple, reprendre et adapter : Société XXXXX, SARL, immatriculée au registre du commerce et des sociétés de PARIS sous le numéro 823 975 529, TVA intracommunautaire FR36823975529, sous contrat d'assurance auprès de AXA Assurances à Paris."
    end
    f.actions
  end


end
