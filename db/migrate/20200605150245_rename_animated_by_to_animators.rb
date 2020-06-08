class RenameAnimatedByToAnimators < ActiveRecord::Migration[6.0]
  def change
    rename_table :animated_by, :animators
  end
end
