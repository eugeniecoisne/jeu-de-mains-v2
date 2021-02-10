class AddNewsletterAgreementToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :newsletter_agreement, :boolean, default: false
  end
end
