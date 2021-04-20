ActiveAdmin.register Animator do
  menu parent: "Fiches"
  config.per_page = 50
  permit_params :user_id, :workshop_id, :workshop, :user, :db_status
  ANIMATOR_WORKSHOPS = Workshop.all.where(db_status: true).sort.map { |w| ["#{w.id} - #{w.title} chez #{w.place.name} - créé le #{w.created_at.strftime("%d/%m/%y")}", w.id] }.to_h
  ANIMATOR_USERS = User.all.select { |u| u.profile.role.present? }.map { |u| ["#{u.fullname} - #{u.profile.company}", u.id] }.to_h

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
    column "Organisateur" do |animator|
      link_to animator.workshop.place.user.profile.company, "#{admin_profile_path(animator.workshop.place.user.profile)}"
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
    column "Organisateur" do |animator|
      animator.workshop.place.user.profile.company
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
      row "Organisateur" do |animator|
        link_to animator.workshop.place.user.profile.company, "#{admin_profile_path(animator.workshop.place.user.profile)}"
      end
      row :created_at
      row :updated_at
      row :db_status
    end
  end

  form do |f|
    f.inputs "Ajouter un animateur à un atelier :" do
      f.input :workshop, collection: ANIMATOR_WORKSHOPS, value: :workshop
      f.input :user, collection: ANIMATOR_USERS, value: :user
      f.input :db_status
    end
    f.actions
  end
end
