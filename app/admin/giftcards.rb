ActiveAdmin.register Giftcard do
  menu parent: "Achats"
  config.per_page = 50
  permit_params :amount, :code, :buyer, :receiver, :status, :db_status, :user_id, :receiver_name, :buyer_name, :message, :cgv_agreement
  GIFTCARD_USERS = User.all.map { |u| ["#{u.first_name} #{u.last_name}", u.id] }.to_h

  index do
    selectable_column
    actions
    column :id
    column :status
    column :db_status
    column :amount
    column :created_at
    column :cgv_agreement
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
    column :buyer_name
    column :receiver do |giftcard|
      if giftcard.receiver.present?
        link_to User.all.select { |u| u.id == giftcard.receiver.to_i }.first.fullname, "#{admin_user_path(User.all.select { |u| u.id == giftcard.receiver.to_i })}"
      end
    end
    column :receiver_name
    column :code
    column :message do |giftcard|
      giftcard.message.present? ? true : false
    end
    column :updated_at
  end

  csv do
    column :id
    column :status
    column :db_status
    column :amount
    column :created_at
    column :cgv_agreement
    column "Valable jusqu'au" do |giftcard|
      (giftcard.deadline_date).strftime("%d/%m/%Y")
    end
    column "Activée ?" do |giftcard|
      giftcard.receiver == giftcard.user.id ? true : false
    end
    column :buyer do |giftcard|
      if giftcard.buyer.present?
        User.all.select { |u| u.id == giftcard.buyer.to_i }.first.fullname
      end
    end
    column :buyer_name
    column :receiver do |giftcard|
      if giftcard.receiver.present?
        User.all.select { |u| u.id == giftcard.receiver.to_i }.first.fullname
      end
    end
    column :receiver_name
    column :code
    column :message do |giftcard|
      giftcard.message.present? ? true : false
    end
    column :updated_at
  end

  show do |giftcard|
    attributes_table do
      row :id
      row :status
      row :db_status
      row :amount
      row :created_at
      row :cgv_agreement
      row "Valable jusqu'au" do |giftcard|
        (giftcard.deadline_date).strftime("%d/%m/%Y")
      end
      row "Activée ?" do |giftcard|
        giftcard.receiver == giftcard.user.id ? true : false
      end
      row :buyer do |giftcard|
        if giftcard.buyer.present?
          link_to User.all.select { |u| u.id == giftcard.buyer.to_i }.first.fullname, "#{admin_user_path(User.all.select { |u| u.id == giftcard.buyer.to_i })}"
        end
      end
      row :buyer_name
      row :receiver do |giftcard|
        if giftcard.receiver.present?
          link_to User.all.select { |u| u.id == giftcard.receiver.to_i }.first.fullname, "#{admin_user_path(User.all.select { |u| u.id == giftcard.receiver.to_i })}"
        end
      end
      row :receiver_name
      row :code
      row :message do |giftcard|
        giftcard.message.present? ? true : false
      end
      row :updated_at
    end
  end


  form do |f|
    f.inputs "Acheteur" do
      f.input :user, collection: GIFTCARD_USERS
    end
    f.inputs "Montant" do
      f.input :amount, as: :select, collection: [20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150]
    end
    f.inputs "Message" do
      f.input :buyer_name, required: true, label: "De la part de"
      f.input :receiver_name, required: true, label: "Pour"
      f.input :message
    end
    f.inputs "Statuts" do
      f.input :db_status, as: :boolean
      f.input :status
      f.input :cgv_agreement, as: :boolean
    end
    f.actions
  end

end
