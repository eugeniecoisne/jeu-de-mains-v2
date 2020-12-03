ActiveAdmin.register Review do

  permit_params :content, :rating, :user_id, :booking_id, :db_status

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
      link_to "#{review.booking.session.workshop.title}", "#{admin_workshop_path(review.booking.session.workshop.title)}"
    end
    column :created_at
    column :updated_at
    column "Session" do |review|
      link_to "#{review.booking.session.date.strftime('%d/%m/%y')}", "#{admin_session_path(review.booking.session)}"
    end
    column "Date de l'atelier" do |review|
      review.booking.session.date.strftime('%d/%m/%y')
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

end
