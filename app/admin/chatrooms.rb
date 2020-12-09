ActiveAdmin.register Chatroom do
  permit_params :room_name, :user1, :user2
  actions :index

  index do
    selectable_column
    column :id
    column :user1 do |chatroom|
      link_to User.find(chatroom.user1).profile.company, "#{admin_profile_path(User.find(chatroom.user1).profile)}"
    end
    column "Rôle chateur 1" do |chatroom|
      User.find(chatroom.user1).profile.role
    end
    column :user2 do |chatroom|
      link_to User.find(chatroom.user2).profile.company, "#{admin_profile_path(User.find(chatroom.user2).profile)}"
    end
    column "Rôle chateur 2" do |chatroom|
      User.find(chatroom.user2).profile.role
    end
    column "Messages" do |chatroom|
      chatroom.messages.count
    end
    column :created_at
    column :updated_at
  end

  csv do
    column :id
    column :user1 do |chatroom|
      User.find(chatroom.user1).profile.company
    end
    column "Rôle chateur 1" do |chatroom|
      User.find(chatroom.user1).profile.role
    end
    column :user2 do |chatroom|
      User.find(chatroom.user2).profile.company
    end
    column "Rôle chateur 2" do |chatroom|
      User.find(chatroom.user2).profile.role
    end
    column "Messages" do |chatroom|
      chatroom.messages.count
    end
    column :created_at
    column :updated_at
  end
end
