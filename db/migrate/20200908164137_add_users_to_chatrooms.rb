class AddUsersToChatrooms < ActiveRecord::Migration[6.0]
  def change
    add_column :chatrooms, :user1, :integer
    add_column :chatrooms, :user2, :integer
  end
end
