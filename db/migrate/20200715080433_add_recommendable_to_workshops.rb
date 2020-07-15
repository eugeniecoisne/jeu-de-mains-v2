class AddRecommendableToWorkshops < ActiveRecord::Migration[6.0]
  def change
    add_column :workshops, :recommendable, :integer, default: 1
  end
end
