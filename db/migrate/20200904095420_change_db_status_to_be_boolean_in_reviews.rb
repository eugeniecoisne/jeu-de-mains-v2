class ChangeDbStatusToBeBooleanInReviews < ActiveRecord::Migration[6.0]
  def change
    change_column :reviews, :db_status, :boolean, using: 'db_status::boolean', default: true
  end
end
