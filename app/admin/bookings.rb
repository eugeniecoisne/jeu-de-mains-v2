ActiveAdmin.register Booking do
  menu parent: "Sessions & Résa"
  permit_params :quantity, :status, :amount, :user_id, :user, :session_id, :session, :db_status, :workshop

  # verif modif
  index do
    selectable_column
    actions
    column :id
    column :status
    column :db_status
    column "Atelier" do |booking|
      link_to "#{booking.session.workshop.title}", "#{admin_workshop_path(booking.session.workshop)}"
    end
    column "Organisateur" do |booking|
      link_to booking.session.workshop.place.user.profile.company, "#{admin_profile_path(booking.session.workshop.place.user.profile)}"
    end
    column :session do |booking|
      link_to "#{booking.session.date.strftime('%d/%m/%y')} à #{booking.session.start_at}", "#{admin_session_path(booking.session)}"
    end
    column "Acheteur" do |booking|
      link_to booking.user.fullname, "#{admin_user_path(booking.user)}"
    end
    column :quantity
    column :amount
    column :created_at
    column :updated_at
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
  end

end
