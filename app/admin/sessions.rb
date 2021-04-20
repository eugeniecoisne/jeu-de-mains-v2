ActiveAdmin.register Session do
  menu parent: "Fiches"
  config.per_page = 50
  permit_params :start_date, :start_time, :end_time, :end_date, :capacity, :workshop_id, :workshop, :db_status, :reason
  SESSION_WORKSHOPS = Workshop.all.where(db_status: true).sort.map { |w| ["#{w.id} - #{w.title} par #{w.place.user.profile.company} - capacité #{w.capacity} places", w.id] }.to_h

  index do
    selectable_column
    actions
    column :id
    column :db_status
    column "En ligne ?" do |session|
      session.start_date >= Date.today && session.workshop.status == "en ligne" && session.db_status == true ? true : false
    end
    column :start_date
    column :start_time
    column :end_date
    column :end_time
    column "Durée" do |session|
      session.workshop.duration
    end
    column :capacity
    column "Places vendues" do |session|
      session.capacity - session.available
    end
    column :workshop
    column "Lieu" do |session|
      link_to session.workshop.place.name, "#{admin_place_path(session.workshop.place)}"
    end
    column "Organisateur" do |session|
      link_to session.workshop.place.user.profile.company, "#{admin_profile_path(session.workshop.place.user.profile)}"
    end
    column "Animateur" do |session|
      if session.workshop.animators.where(db_status: true).present?
        link_to session.workshop.animators.where(db_status: true).last.user.profile.company, "#{admin_profile_path(session.workshop.animators.where(db_status: true).last.user.profile)}"
      end
    end
    column "ID Animation" do |session|
      if session.workshop.animators.where(db_status: true).present?
        link_to session.workshop.animators.where(db_status: true).last.id, "#{admin_animator_path(session.workshop.animators.where(db_status: true).last)}"
      end
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
    column "Note JDM non utilisée" do |session|
      session.workshop.recommendable
    end
    column :reason
    column :created_at
    column :updated_at
  end

  csv do
    column :id
    column :db_status
    column "En ligne ?" do |session|
      session.start_date >= Date.today && session.workshop.status == "en ligne" && session.db_status == true ? true : false
    end
    column :date
    column :start_time
    column :end_date
    column :end_time
    column "Durée" do |session|
      session.workshop.duration
    end
    column :capacity
    column "Places vendues" do |session|
      session.capacity - session.available
    end
    column :workshop do |session|
      session.workshop.title
    end
    column "Lieu" do |session|
      session.workshop.place.name
    end
    column "Organisateur" do |session|
      session.workshop.place.user.profile.company
    end
    column "Animateur" do |session|
      if session.workshop.animators.where(db_status: true).present?
        session.workshop.animators.where(db_status: true).last.user.profile.company
      end
    end
    column "ID Animation" do |session|
      if session.workshop.animators.where(db_status: true).present?
        session.workshop.animators.where(db_status: true).last.id
      end
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
    column "Note JDM non utilisée" do |session|
      session.workshop.recommendable
    end
    column :reason
    column :created_at
    column :updated_at
  end

  show do |session|
    attributes_table do
      row "Atelier" do |session|
        link_to "#{session.workshop.title}", "#{admin_workshop_path(session.workshop)}"
      end
      row "Organisateur" do |session|
        link_to "#{session.workshop.place.name}", "#{admin_place_path(session.workshop.place)}"
      end
      row "Animateur" do |session|
        if session.workshop.animators.where(db_status: true).present?
          link_to session.workshop.animators.where(db_status: true).last.user.profile.company, "#{admin_profile_path(session.workshop.animators.where(db_status: true).last.user.profile)}"
        end
      end
      row "ID Animation" do |session|
        if session.workshop.animators.where(db_status: true).present?
          link_to session.workshop.animators.where(db_status: true).last.id, "#{admin_animator_path(session.workshop.animators.where(db_status: true).last)}"
        end
      end
      row "Ville" do |session|
        session.workshop.place.city
      end
      row :start_date do |session|
        session.start_date.strftime('%d/%m/%Y')
      end
      row :start_time
      row :end_date do |session|
        session.end_date.strftime('%d/%m/%Y')
      end
      row :end_time
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
      row "En ligne ?" do |session|
        session.start_date >= Date.today && session.workshop.status == "en ligne" && session.db_status == true ? true : false
      end
      row :reason
    end
    if session.bookings.present?
      panel "Réservations" do
        table_for session.bookings do
          column :user do |booking|
            link_to "#{booking.user.fullname}", "#{admin_user_path(booking.user)}"
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
      f.input :workshop, collection: SESSION_WORKSHOPS, value: :workshop
    end
    f.inputs "Date et heure" do
      f.input :start_date
      f.input :start_time, collection: Session::STARTS_AT
      f.input :end_date
      f.input :end_time, collection: Session::ENDS_AT
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
