ActiveAdmin.register Session do
  menu parent: "Sessions & Résa"
  permit_params :date, :start_at, :capacity, :workshop_id, :workshop, :db_status, :reason

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

end
