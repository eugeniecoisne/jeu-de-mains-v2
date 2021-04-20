ActiveAdmin.register Place do
  menu parent: "Fiches"
  config.per_page = 50
  remove_filter :latitude, :longitude
  preserve_default_filters!
  PLACE_USERS = User.all.select { |u| u.profile.company.present? == true }.map { |u| [u.profile.company, u.id] }.to_h

  index do

    selectable_column
    actions
    column :id
    column :db_status
    column :name
    column "Auteur" do |place|
      link_to "#{place.user.fullname} / #{place.user.profile.company}", "#{admin_user_path(place.user)}"
    end
    column :address
    column :zip_code
    column :city
    column :phone_number
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
    column :created_at
    column :updated_at
  end


  csv do

    column :id
    column :db_status
    column :name
    column :user_id
    column "Propriétaire Prénom Nom" do |place|
      place.user.fullname
    end
    column "Propriétaire Entreprise" do |place|
      place.user.profile.company
    end
    column :address
    column :zip_code
    column :city
    column :phone_number
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
    column :created_at
    column :updated_at
  end

  show do |place|

    attributes_table do
      row :name
      row "Auteur" do |place|
        link_to "#{place.user.fullname} / #{place.user.profile.company}", "#{admin_user_path(place.user)}"
      end
      row :address
      row :zip_code
      row :city
      row :phone_number
      row "Nb ateliers en ligne" do |place|
        Workshop.all.where(db_status: true, status: "en ligne").select { |w| w.place == place}.count
      end
      row "Nb sessions en ligne" do |place|
        Session.all.where(db_status: true).select { |s| s.workshop.place == place && s.date > Date.today }.count
      end
      row :created_at
      row :updated_at
      row :db_status
      row :latitude
      row :longitude
    end

    if Workshop.all.select { |w| w.place == place}.count > 0
      panel "Ateliers" do
        table_for Workshop.all.select { |w| w.place == place}.sort_by { |w| w.created_at } do
          column "Atelier" do |workshop|
            link_to workshop.title, "#{admin_workshop_path(workshop)}"
          end
          column "Animé par" do |workshop|
            if workshop.animators.where(db_status: true).present?
              link_to workshop.animators.where(db_status: true).last.user.profile.company, "#{admin_profile_path(workshop.animators.where(db_status: true).last.user.profile)}"
            end
          end
          column "Créé le" do |workshop|
            workshop.created_at.strftime("%d/%m/%Y")
          end
          column :ephemeral
          column "Nb sessions en ligne" do |workshop|
            workshop.sessions.where(db_status: true).select { |s| s.date > Date.today }.count
          end
          column :status
          column :db_status
        end
      end
    end
  end

  form do |f|
    f.inputs "Propriétaire et nom du lieu" do
      f.input :user, collection: PLACE_USERS, value: :user
      f.input :name
    end
    f.inputs "Adresse" do
      f.input :address
      f.input :zip_code
      f.input :city
    end
    f.inputs "Coordonnées" do
      f.input :phone_number
    end
    f.inputs "Statuts" do
      f.input :db_status, as: :boolean
    end
    f.actions
  end


  permit_params :name, :address, :zip_code, :city, :phone_number, :user, :user_id, :db_status, :latitude, :longitude

end
