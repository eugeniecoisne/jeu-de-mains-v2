class AddDbStatusToReviews < ActiveRecord::Migration[6.0]
  def change
    add_column :reviews, :db_status, :string
  end
end
