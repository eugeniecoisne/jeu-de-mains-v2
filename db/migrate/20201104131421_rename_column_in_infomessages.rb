class RenameColumnInInfomessages < ActiveRecord::Migration[6.0]
  def change
    rename_column :infomessages, :subjet, :subject
  end
end
