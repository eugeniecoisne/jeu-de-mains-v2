ActiveAdmin.register Booking do
  menu parent: "Achats"
  config.per_page = 50
  permit_params :quantity, :status, :amount, :user_id, :user, :session_id, :session, :db_status, :workshop, :address, :address_complement, :zip_code, :city, :phone_number
  BOOKING_SESSIONS = Session.all.where(db_status: true).sort_by { |s| s.date }.map { |s| ["#{s.id} - #{s.date.strftime("%d/%m/%y")} à #{s.start_at} - #{s.workshop.title} chez #{s.workshop.place.name} - #{s.available} places restantes", s.id] }.to_h
  BOOKING_USERS = User.all.select { |u| u.profile.company.present? == false }.map { |u| ["#{u.first_name} #{u.last_name}", u.id] }.to_h

  index do
    selectable_column
    actions
    column :id
    column :status
    column :db_status
    column "Acheteur" do |booking|
      link_to booking.user.fullname, "#{admin_user_path(booking.user)}"
    end
    column "Atelier" do |booking|
      link_to "#{booking.session.workshop.title}", "#{admin_workshop_path(booking.session.workshop)}"
    end
    column :session do |booking|
      link_to "#{booking.session.date.strftime('%d/%m/%y')} à #{booking.session.start_at}", "#{admin_session_path(booking.session)}"
    end
    column :quantity
    column :amount
    column :created_at
    column :updated_at
    column :cancelled_at
    column "Lieu" do |booking|
      link_to booking.session.workshop.place.name, "#{admin_place_path(booking.session.workshop.place)}"
    end
    column "Organisateur" do |booking|
      link_to booking.session.workshop.place.user.profile.company, "#{admin_profile_path(booking.session.workshop.place.user.profile)}"
    end
    column "Animateur" do |booking|
      if booking.session.workshop.animators.where(db_status: true).present?
        link_to booking.session.workshop.animators.where(db_status: true).last.user.profile.company, "#{admin_profile_path(booking.session.workshop.animators.where(db_status: true).last.user.profile)}"
      end
    end
    column "ID Animation" do |booking|
      if booking.session.workshop.animators.where(db_status: true).present?
        link_to booking.session.workshop.animators.where(db_status: true).last.id, "#{admin_animator_path(booking.session.workshop.animators.where(db_status: true).last)}"
      end
    end
    column "Thématique" do |booking|
      booking.session.workshop.thematic
    end
    column "Ville Atelier" do |booking|
      booking.session.workshop.place.city
    end
    column "Code Postal Atelier" do |booking|
      booking.session.workshop.place.zip_code
    end
    column "Avis posté ?" do |booking|
      booking.reviews.present? ? true : false
    end
    column "Note donnée /5" do |booking|
      booking.reviews.last.rating if booking.reviews.present?
    end
    column :address
    column :address_complement
    column :zip_code
    column :city
    column :phone_number
  end

  csv do
    column :id
    column :status
    column :db_status
    column :user_id
    column "Acheteur - Nom" do |booking|
      booking.user.last_name
    end
    column "Acheteur - Prénom" do |booking|
      booking.user.first_name
    end
    column "Atelier" do |booking|
      booking.session.workshop.title
    end
    column "Date de l'atelier" do |booking|
      booking.session.date.strftime('%d/%m/%y')
    end
    column "Heure de l'atelier" do |booking|
      booking.session.start_at
    end
    column :quantity
    column :amount
    column :created_at
    column :updated_at
    column :cancelled_at
    column "Lieu" do |booking|
      booking.session.workshop.place.name
    end
    column "Organisateur" do |booking|
      booking.session.workshop.place.user.profile.company
    end
    column "Animateur" do |booking|
      if booking.session.workshop.animators.where(db_status: true).present?
        booking.session.workshop.animators.where(db_status: true).last.user.profile.company
      end
    end
    column "ID Animation" do |booking|
      if booking.session.workshop.animators.where(db_status: true).present?
        booking.session.workshop.animators.where(db_status: true).last.id
      end
    end
    column "Thématique" do |booking|
      booking.session.workshop.thematic
    end
    column "Ville Atelier" do |booking|
      booking.session.workshop.place.city
    end
    column "Code Postal Atelier" do |booking|
      booking.session.workshop.place.zip_code
    end
    column "Avis posté ?" do |booking|
      booking.reviews.present? ? true : false
    end
    column "Note donnée /5" do |booking|
      booking.reviews.last.rating if booking.reviews.present?
    end
    column :address
    column :address_complement
    column :zip_code
    column :city
    column :phone_number
  end

  show do |booking|
    attributes_table do
      row :id
      row :status
      row :db_status
      row "Acheteur" do |booking|
        link_to booking.user.fullname, "#{admin_user_path(booking.user)}"
      end
      row "Atelier" do |booking|
        link_to "#{booking.session.workshop.title}", "#{admin_workshop_path(booking.session.workshop)}"
      end
      row :session do |booking|
        link_to "#{booking.session.date.strftime('%d/%m/%y')} à #{booking.session.start_at}", "#{admin_session_path(booking.session)}"
      end
      row :quantity
      row :amount
      row :created_at
      row :updated_at
      row :cancelled_at
      row "Lieu" do |booking|
        link_to booking.session.workshop.place.name, "#{admin_place_path(booking.session.workshop.place)}"
      end
      row "Organisateur" do |booking|
        link_to booking.session.workshop.place.user.profile.company, "#{admin_profile_path(booking.session.workshop.place.user.profile)}"
      end
      row "Animateur" do |booking|
        if booking.session.workshop.animators.where(db_status: true).present?
          link_to booking.session.workshop.animators.where(db_status: true).last.user.profile.company, "#{admin_profile_path(booking.session.workshop.animators.where(db_status: true).last.user.profile)}"
        end
      end
      row "ID Animation" do |booking|
        if booking.session.workshop.animators.where(db_status: true).present?
          link_to booking.session.workshop.animators.where(db_status: true).last.id, "#{admin_animator_path(booking.session.workshop.animators.where(db_status: true).last)}"
        end
      end
      row "Thématique" do |booking|
        booking.session.workshop.thematic
      end
      row "Ville Atelier" do |booking|
        booking.session.workshop.place.city
      end
      row "Code Postal Atelier" do |booking|
        booking.session.workshop.place.zip_code
      end
      row "Avis posté ?" do |booking|
        booking.reviews.present? ? true : false
      end
      row "Note donnée /5" do |booking|
        booking.reviews.last.rating if booking.reviews.present?
      end
      row :address
      row :address_complement
      row :zip_code
      row :city
      row :phone_number
    end
  end

  form do |f|
    f.inputs "Session et acheteur" do
      f.input :session, collection: BOOKING_SESSIONS
      f.input :user, collection: BOOKING_USERS
    end
    f.inputs "Quantité" do
      f.input :quantity
    end
    f.inputs "Coordonnées" do
      f.input :address
      f.input :address_complement
      f.input :zip_code
      f.input :city
      f.input :phone_number
    end
    f.inputs "Statut" do
      f.input :status
      f.input :db_status
    end
    f.actions
  end

end
