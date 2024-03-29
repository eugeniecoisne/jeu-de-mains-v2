ActiveAdmin.register User do
  config.per_page = 50
  remove_filter :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at, :confirmation_token, :confirmation_sent_at, :uid
  permit_params :id, :first_name, :last_name, :email, :password, :password_confirmation, :created_by_admin, :newsletter_agreement, :cgu_agreement, :db_status, :stripe_uid, :access_code, :publishable_key, :stripe_provider

  index do
    selectable_column
    actions
    column :id
    column :db_status
    column :newsletter_agreement
    column "Rôle" do |user|
      user.profile.role
    end
    column :profile do |user|
      if user.profile.company.present?
        link_to user.profile.company, "#{admin_profile_path(user.profile)}"
      else
        link_to "Profil #{user.profile.id}", "#{admin_profile_path(user.profile)}"
      end
    end
    column :first_name
    column :last_name
    column :email
    column :created_at
    column :confirmation_sent_at
    column :confirmed_at
    column :updated_at
    column :provider
    column :cgu_agreement
    column :admin
  end

  csv do
    column :id
    column :db_status
    column :newsletter_agreement
    column :profile do |user|
      user.profile.company
    end
    column "Rôle" do |user|
      user.profile.role
    end
    column :first_name
    column :last_name
    column :email
    column :created_at
    column :confirmation_sent_at
    column :confirmed_at
    column :updated_at
    column :provider
    column :cgu_agreement
    column :admin
  end

  show :title => :fullname do
    attributes_table do
      row :profile
      row "Rôle" do |user|
        user.profile.role
      end
      row :admin
      row :cgu_agreement
      row :last_name
      row :first_name
      row :email
      row :newsletter_agreement
      row :db_status
      row :created_at
      row :confirmation_sent_at
      row :confirmed_at
      row :updated_at
      row :provider
      row :stripe_uid
      row :access_code
      row :publishable_key
      row :stripe_provider
    end


    if Giftcard.all.where(db_status: true).select { |g| g.buyer == user.id }.count > 0
      panel "Cartes cadeaux offertes" do
        table_for (Giftcard.all.where(db_status: true).select { |g| g.buyer == user.id }) do
          column :id do |giftcard|
            link_to giftcard.id, "#{admin_giftcard_path(giftcard)}"
          end
          column :amount
          column :code
          column :created_at do |giftcard|
            giftcard.created_at.strftime('%d/%m/%Y')
          end
          column "Valable jusqu'au" do |giftcard|
            (giftcard.deadline_date).strftime("%d/%m/%Y")
          end
          column "Activée ?" do |giftcard|
            giftcard.receiver == giftcard.user.id ? true : false
          end
          column :receiver do |giftcard|
            if giftcard.receiver.present?
              link_to User.all.select { |u| u.id == giftcard.receiver.to_i }.first.fullname, "#{admin_user_path(User.all.select { |u| u.id == giftcard.receiver.to_i })}"
            end
          end
          column :status
          column :db_status
        end
      end
    end

    if Giftcard.all.where(db_status: true).select { |g| g.receiver == user.id }.count > 0
      panel "Cartes cadeaux reçues" do
        table_for (Giftcard.all.where(db_status: true).select { |g| g.receiver == user.id }) do
          column :id do |giftcard|
            link_to giftcard.id, "#{admin_giftcard_path(giftcard)}"
          end
          column :amount
          column :code
          column :created_at do |giftcard|
            giftcard.created_at.strftime('%d/%m/%Y')
          end
          column "Valable jusqu'au" do |giftcard|
            (giftcard.deadline_date).strftime("%d/%m/%Y")
          end
          column "Activée ?" do |giftcard|
            giftcard.receiver == giftcard.user.id ? true : false
          end
          column :buyer do |giftcard|
            if giftcard.buyer.present?
              link_to User.all.select { |u| u.id == giftcard.buyer.to_i }.first.fullname, "#{admin_user_path(User.all.select { |u| u.id == giftcard.buyer.to_i })}"
            end
          end
          column :status
          column :db_status
        end
      end
    end
  end

  form do |f|
    f.inputs "Nom, prénom, e-mail, newsletter" do
      f.input :last_name
      f.input :first_name
      f.input :email
      f.input :newsletter_agreement
    end
    f.inputs "Mot de Passe" do
      f.input :password
      f.input :password_confirmation
    end
    f.inputs "CGU" do
      f.input :cgu_agreement
    end
    f.inputs "Statut" do
      f.input :db_status
    end
    f.inputs "Stripe" do
      f.input :stripe_uid
      f.input :access_code
      f.input :publishable_key
      f.input :stripe_provider
    end
    f.inputs "Créé par l'admin" do
      f.input :created_by_admin, value: true
    end
    f.actions
  end
end
