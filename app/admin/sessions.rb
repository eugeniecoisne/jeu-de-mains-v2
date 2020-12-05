ActiveAdmin.register Session do
  menu parent: "Sessions & Résa"
  permit_params :date, :start_at, :capacity, :workshop_id, :workshop, :db_status, :reason
  SESSION_WORKSHOPS = Workshop.all.where(db_status: true).sort.map { |w| ["#{w.id} - #{w.title} par #{w.place.name} - capacité #{w.capacity} places", w.id] }.to_h

  index do
    selectable_column
    actions
    column :id
    column :db_status
    column :date
    column :start_at
    column "Durée" do |session|
      session.workshop.duration
    end
    column :capacity
    column :workshop
    column "Organisateur" do |session|
      session.workshop.place.user.profile.company
    end
    column "Thématique" do |session|
      session.workshop.thematic
    end
    column "Ville" do |session|
      session.workshop.place.city
    end
    column "Code Postal" do |session|
      session.workshop.place.zip_code
    end
    column "Prix" do |session|
      session.workshop.price
    end
    column "Note JDM" do |session|
      session.workshop.recommendable
    end
    column :reason
  end

  csv do
    column :id
    column :db_status
    column :date
    column :start_at
    column "Durée" do |session|
      session.workshop.duration
    end
    column :capacity
    column :workshop do |session|
      session.workshop.title
    end
    column "Organisateur" do |session|
      session.workshop.place.user.profile.company
    end
    column "Thématique" do |session|
      session.workshop.thematic
    end
    column "Ville" do |session|
      session.workshop.place.city
    end
    column "Code Postal" do |session|
      session.workshop.place.zip_code
    end
    column "Prix" do |session|
      session.workshop.price
    end
    column "Note JDM" do |session|
      session.workshop.recommendable
    end
    column :reason
  end

  show do |session|
    attributes_table do
      row "Atelier" do |session|
        link_to "#{session.workshop.title}", "#{admin_workshop_path(session.workshop)}"
      end
      row "Organisateur" do |session|
        link_to "#{session.workshop.place.name}", "#{admin_place_path(session.workshop.place)}"
      end
      row "Ville" do |session|
        session.workshop.place.city
      end
      row :date do |session|
        session.date.strftime('%d/%m/%Y')
      end
      row :start_at
      row :capacity
      row "Places vendues" do |session|
        session.capacity - session.available
      end
      row "Places restantes" do |session|
        session.available
      end
      row :created_at
      row :updated_at
      row :db_status
      row :reason
    end
    if session.bookings.present?
      panel "Réservations" do
        table_for session.bookings do
          column :user do |booking|
            link_to "#{booking.user.first_name} #{booking.user.last_name}", "#{admin_user_path(booking.user)}"
          end
          column "Réservation" do |booking|
            link_to "#{booking.id}", "#{admin_booking_path(booking)}"
          end
          column :quantity
          column :db_status
          column :created_at
        end
      end
    end
  end

  form do |f|
    f.inputs "Atelier" do
      f.input :workshop, collection: SESSION_WORKSHOPS
    end
    f.inputs "Date et heure" do
      f.input :date
      f.input :start_at, collection: Session::STARTS_AT
    end
    f.inputs "Capacité (obligatoire)" do
      f.input :capacity
    end
    f.inputs "Raison en cas d'annulation" do
      f.input :reason
    end
    f.inputs "Statut" do
      f.input :db_status
    end
    f.actions
  end

end