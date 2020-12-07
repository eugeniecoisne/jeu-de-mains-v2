ActiveAdmin.register Review do

  permit_params :content, :rating, :user_id, :booking_id, :db_status
  REVIEW_USERS = User.all.select { |u| u.profile.company.present? == false }.map { |u| ["#{u.first_name} #{u.last_name}", u.id] }.to_h
  REVIEW_BOOKINGS = Booking.all.where(db_status: true).select { |b| b.reviews.present? == false }.map { |b| ["Réservation n° #{b.id} du #{b.created_at} de #{b.user.first_name} #{b.user.last_name}", b.id] }.to_h

  index do
    selectable_column
    actions
    column :id
    column :db_status
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
      link_to "#{review.booking.session.workshop.title}", "#{admin_workshop_path(review.booking.session.workshop)}"
    end
    column :created_at
    column :updated_at
    column "Session" do |review|
      link_to "#{review.booking.session.date.strftime('%d/%m/%y')}", "#{admin_session_path(review.booking.session)}"
    end
    column "Organisateur" do |review|
      review.booking.session.workshop.place.user.profile.company
    end
    column "Ville" do |review|
      review.booking.session.workshop.place.city
    end
    column "Code Postal" do |review|
      review.booking.session.workshop.place.zip_code
    end
  end

  csv do
    column :id
    column :db_status
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
    column :created_at
    column :updated_at
    column "Date de session" do |review|
      review.booking.session.date.strftime('%d/%m/%y')
    end
    column "Heure de session" do |review|
      review.booking.session.start_at
    end
    column "Organisateur" do |review|
      review.booking.session.workshop.place.user.profile.company
    end
    column "Ville" do |review|
      review.booking.session.workshop.place.city
    end
    column "Code Postal" do |review|
      review.booking.session.workshop.place.zip_code
    end
  end

  show do |review|
    attributes_table do
      row "Atelier" do |review|
        link_to "#{review.booking.session.workshop.title}", "#{admin_workshop_path(review.booking.session.workshop)}"
      end
      row "Organisateur" do |review|
        link_to "#{review.booking.session.workshop.place.name}", "#{admin_place_path(review.booking.session.workshop.place)}"
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
        link_to "#{review.user.id} - #{review.user.first_name} #{review.user.last_name}", "#{admin_user_path(review.user)}"
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
