ActiveAdmin.register Review do
  config.per_page = 50
  permit_params :content, :rating, :user_id, :booking_id, :db_status
  REVIEW_USERS = User.all.select { |u| u.profile.company.present? == false }.map { |u| ["#{u.first_name} #{u.last_name}", u.id] }.to_h
  REVIEW_BOOKINGS = Booking.all.where(db_status: true, status: "paid").select { |b| b.reviews.present? == false }.map { |b| ["Réservation n° #{b.id} du #{b.created_at} de #{b.user.fullname}", b.id] }.to_h

  index do
    selectable_column
    actions
    column :id
    column :db_status
    column :created_at
    column "Auteur" do |review|
      link_to review.booking.user.fullname, "#{admin_user_path(review.booking.user)}"
    end
    column :rating
    column :content
    column :booking_id
    column "Atelier" do |review|
      link_to "#{review.booking.session.workshop.title}", "#{admin_workshop_path(review.booking.session.workshop)}"
    end
    column "Session" do |review|
      link_to "#{review.booking.session.date.strftime('%d/%m/%y')} à #{review.booking.session.start_at}", "#{admin_session_path(review.booking.session)}"
    end
    column "Lieu" do |review|
      link_to "#{review.booking.session.workshop.place.name}", "#{admin_place_path(review.booking.session.workshop.place)}"
    end
    column "Organisateur" do |review|
      link_to review.booking.session.workshop.place.user.profile.company, "#{admin_profile_path(review.booking.session.workshop.place.user.profile)}"
    end
    column "Animateur" do |review|
      if review.booking.session.workshop.animators.where(db_status: true).present?
        link_to review.booking.session.workshop.animators.where(db_status: true).last.user.profile.company, "#{admin_profile_path(review.booking.session.workshop.animators.where(db_status: true).last.user.profile)}"
      end
    end
    column "ID Animation" do |review|
      if review.booking.session.workshop.animators.where(db_status: true).present?
        link_to review.booking.session.workshop.animators.where(db_status: true).last.id, "#{admin_animator_path(review.booking.session.workshop.animators.where(db_status: true).last)}"
      end
    end
    column "Ville" do |review|
      review.booking.session.workshop.place.city
    end
    column "Code Postal" do |review|
      review.booking.session.workshop.place.zip_code
    end
    column :updated_at
  end

  csv do
    column :id
    column :db_status
    column :created_at
    column :user_id
    column "Nom" do |review|
      review.booking.user.last_name
    end
    column "Prénom" do |review|
      review.booking.user.first_name
    end
    column :rating
    column :content
    column :booking_id
    column "Atelier" do |review|
      review.booking.session.workshop.title
    end
    column "Date de session" do |review|
      review.booking.session.date.strftime('%d/%m/%y')
    end
    column "Heure de session" do |review|
      review.booking.session.start_at
    end
    column "Lieu" do |review|
      review.booking.session.workshop.place.name
    end
    column "Organisateur" do |review|
      review.booking.session.workshop.place.user.profile.company
    end
    column "Animateur" do |review|
      if review.booking.session.workshop.animators.where(db_status: true).present?
        review.booking.session.workshop.animators.where(db_status: true).last.user.profile.company
      end
    end
    column "ID Animation" do |review|
      if review.booking.session.workshop.animators.where(db_status: true).present?
        review.booking.session.workshop.animators.where(db_status: true).last.id
      end
    end
    column "Ville" do |review|
      review.booking.session.workshop.place.city
    end
    column "Code Postal" do |review|
      review.booking.session.workshop.place.zip_code
    end
    column :updated_at
  end

  show do |review|
    attributes_table do
      row "Atelier" do |review|
        link_to "#{review.booking.session.workshop.title}", "#{admin_workshop_path(review.booking.session.workshop)}"
      end
      row "Organisateur" do |review|
        link_to "#{review.booking.session.workshop.place.name}", "#{admin_place_path(review.booking.session.workshop.place)}"
      end
      row "Animateur" do |review|
        if review.booking.session.workshop.animators.where(db_status: true).present?
          link_to review.booking.session.workshop.animators.where(db_status: true).last.user.profile.company, "#{admin_profile_path(review.booking.session.workshop.animators.where(db_status: true).last.user.profile)}"
        end
      end
      row "ID Animation" do |review|
        if review.booking.session.workshop.animators.where(db_status: true).present?
          link_to review.booking.session.workshop.animators.where(db_status: true).last.id, "#{admin_animator_path(review.booking.session.workshop.animators.where(db_status: true).last)}"
        end
      end
      row "Ville" do |review|
        review.booking.session.workshop.place.city
      end
      row :booking
      row "Session" do |review|
        link_to "#{review.booking.session.date.strftime('%d/%m/%y')} à #{review.booking.session.start_at}", "#{admin_session_path(review.booking.session)}"
      end
      row :content
      row :rating
      row :user do |review|
        link_to "#{review.user.id} - #{review.user.fullname}", "#{admin_user_path(review.user)}"
      end
      row :created_at
      row :updated_at
      row :db_status
    end
  end

  form do |f|
    f.inputs "Auteur et Réservation" do
      f.input :user, collection: REVIEW_USERS
      f.input :booking, collection: REVIEW_BOOKINGS
    end
    f.inputs "Contenu et Note" do
      f.input :content
      f.input :rating, collection: (1..5).to_a
    end
    f.inputs "Statut" do
      f.input :db_status
    end
    f.actions
  end

end
