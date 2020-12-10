ActiveAdmin.register Animator do
  menu parent: "Fiches"
  permit_params :user_id, :workshop_id, :workshop, :user, :db_status
  ANIMATOR_WORKSHOPS = Workshop.all.where(db_status: true).sort.map { |w| ["#{w.id} - #{w.title} chez #{w.place.name} - créé le #{w.created_at.strftime("%d/%m/%y")}", w.id] }.to_h
  ANIMATOR_USERS = User.all.select { |u| u.profile.role == "animateur" }.map { |u| ["#{u.fullname} - #{u.profile.company}", u.id] }.to_h

  controller do
    def find_resource
      begin
        scoped_collection.where(slug: params[:id]).first!
      rescue ActiveRecord::RecordNotFound
        scoped_collection.find(params[:id])
      end
    end
  end

  index do
    selectable_column
    actions
    column :id
    column :db_status
    column "Animateur" do |animator|
      link_to "#{animator.user.profile.company}", "#{admin_profile_path(animator.user.profile)}"
    end
    column :workshop do |animator|
      link_to animator.workshop.title, "#{admin_workshop_path(animator.workshop)}"
    end
    column "Lieu" do |animator|
      link_to animator.workshop.place.name, "#{admin_place_path(animator.workshop.place)}"
    end
    column :created_at
    column :updated_at
  end

  csv do
    column :id
    column :db_status
    column "Animateur" do |animator|
      animator.user.profile.company
    end
    column :workshop do |animator|
      animator.workshop.title
    end
    column "Lieu" do |animator|
      animator.workshop.place.name
    end
    column :created_at
    column :updated_at
  end

  show do
    attributes_table do
      row :id
      row "Animateur" do |animator|
        link_to "#{animator.user.profile.company}", "#{admin_profile_path(animator.user.profile)}"
      end
      row :workshop do |animator|
        link_to animator.workshop.title, "#{admin_workshop_path(animator.workshop)}"
      end
      row :created_at
      row :updated_at
      row :db_status
    end
  end

  form do |f|
    f.inputs "Ajouter un animateur à un atelier :" do
      f.input :workshop, collection: ANIMATOR_WORKSHOPS
      f.input :user, collection: ANIMATOR_USERS
      f.input :db_status
    end
    f.actions
  end
end
