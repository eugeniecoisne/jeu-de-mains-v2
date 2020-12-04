ActiveAdmin.register Booking do
  menu parent: "Sessions & Résa"
  permit_params :quantity, :status, :amount, :user_id, :user, :session_id, :session, :db_status, :workshop


  def scoped_collection
    super.includes :workshop # prevents N+1 queries to your database
  end

  index do
    selectable_column
    actions
    column :id
    column :status
    column :db_status
    column :user_id
    column :workshop
    column "Nom" do |booking|
      booking.user.last_name
    end
    column "Prénom" do |booking|
      booking.user.first_name
    end
    column :created_at
    column :updated_at
    column :quantity
    column :amount
    column :session_id
    column "Date de l'atelier" do |booking|
      booking.session.date.strftime('%d/%m/%y')
    end
    column "Atelier" do |booking|
      link_to "#{booking.session.workshop.title}", "#{admin_workshop_path(booking.session.workshop.title)}"
    end
    column "Organisateur" do |booking|
      booking.session.workshop.place.user.profile.company
    end
    column "Ville" do |booking|
      booking.session.workshop.place.city
    end
    column "Code Postal" do |booking|
      booking.session.workshop.place.zip_code
    end
  end

end
