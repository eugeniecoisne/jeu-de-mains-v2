class AddLegalMentionToProfiles < ActiveRecord::Migration[6.0]
  def change
    add_column :profiles, :legal_mention, :text
  end
end
