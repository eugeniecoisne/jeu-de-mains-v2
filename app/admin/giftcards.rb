ActiveAdmin.register Giftcard do
  menu parent: "Achats"
  permit_params :amount, :code, :buyer, :receiver, :status, :db_status, :user_id, :receiver_name, :buyer_name, :message

end
