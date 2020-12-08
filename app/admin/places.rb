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
    column "Auteur" do |place|
      link_to "#{place.user.fullname} / #{place.user.profile.company}", "#{admin_user_path(place.user)}"
    end
    column :ephemeral
    column :siret_number
    column :address
    column :zip_code
    column :city
    column :phone_number
    column :email
    column :website
    column :instagram
    column :description do |place|
      place.description.present? ? true : false
    end
    column "Nb ateliers en ligne" do |place|
      Workshop.all.where(db_status: true, status: "en ligne").select { |w| w.place == place}.count
    end
    column "Nb sessions en ligne" do |place|
      Session.all.where(db_status: true).select { |s| s.workshop.place == place && s.date > Date.today }.count
    end
    column "Participants reçus" do |place|
      participants = 0
      Session.all.select { |s| s.workshop.place == place && s.date < Date.today }.each { |s| participants += s.sold }
      participants
    end
    column :rating
    column "Nombre d'avis" do |place|
      Review.all.where(db_status: true).select { |r| r.booking.session.workshop.place == place }.count
    end
    column :created_at
    column :updated_at
    column "Voir page publique" do |place|
      link_to "Lien page", "#{place_path(place)}", target: "_blank"
    end
    column "Photo" do |place|
      link_to "Lien photo", "#{cl_image_path place.photo.key}", target: "_blank"
    end
  end


  csv do

    column :id
    column :db_status
    column :verified
    column :name
    column :user_id
    column "Propriétaire Prénom Nom" do |place|
      place.user.fullname
    end
    column "Propriétaire Entreprise" do |place|
      place.user.profile.company
    end
    column :ephemeral
    column :siret_number
    column :address
    column :zip_code
    column :city
    column :phone_number
    column :email
    column :website
    column :instagram
    column :description
    column "Nb ateliers en ligne" do |place|
      Workshop.all.where(db_status: true, status: "en ligne").select { |w| w.place == place}.count
    end
    column "Nb sessions en ligne" do |place|
      Session.all.where(db_status: true).select { |s| s.workshop.place == place && s.date > Date.today }.count
    end
    column "Participants reçus" do |place|
      participants = 0
      Session.all.select { |s| s.workshop.place == place && s.date < Date.today }.each { |s| participants += s.sold }
      participants
    end
    column :rating
    column "Nombre d'avis" do |place|
      Review.all.where(db_status: true).select { |r| r.booking.session.workshop.place == place }.count
    end
    column :created_at
    column :updated_at
    column "Photo" do |place|
      "#{cl_image_path place.photo.key}"
    end
  end

  show do |place|

    PLACE_REVIEWS = Review.all.where(db_status: true).select { |r| r.booking.session.workshop.place == place }.sort_by { |r| r.created_at }

    attributes_table do
      row "Photo" do |place|
        if place.photo.attached?
          cl_image_tag place.photo.key, width: 100, height: 100, crop: :fill
        end
      end
      row :name
      row "Auteur" do |place|
        link_to "#{place.user.fullname} / #{place.user.profile.company}", "#{admin_user_path(place.user)}"
      end
      row :ephemeral
      row :siret_number
      row :address
      row :zip_code
      row :city
      row :phone_number
      row :email
      row :website
      row :instagram
      row :description
      row "Nb ateliers en ligne" do |place|
        Workshop.all.where(db_status: true, status: "en ligne").select { |w| w.place == place}.count
      end
      row "Nb sessions en ligne" do |place|
        Session.all.where(db_status: true).select { |s| s.workshop.place == place && s.date > Date.today }.count
      end
      row "Participants reçus" do |place|
        participants = 0
        Session.all.select { |s| s.workshop.place == place && s.date < Date.today }.each { |s| participants += s.sold }
        participants
      end
      row :rating
      row "Nombre d'avis" do |place|
        PLACE_REVIEWS.count
      end
      row :created_at
      row :updated_at
      row :db_status
      row :verified
      row :latitude
      row :longitude
      row :slug
      row "Voir page publique" do |workshop|
        link_to "Voir", "#{place_path(place)}", target: "_blank"
      end
    end

    if Workshop.all.select { |w| w.place == place}.count > 0
      panel "Ateliers" do
        table_for Workshop.all.select { |w| w.place == place}.sort_by { |w| w.created_at } do
          column "Atelier" do |workshop|
            link_to "Voir", "#{admin_workshop_path(workshop)}"
          end
          column :title
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
          column :status
          column :db_status
        end
      end
    end
    if PLACE_REVIEWS.size > 0
      panel "Avis" do
        table_for PLACE_REVIEWS do
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
