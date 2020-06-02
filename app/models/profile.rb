class Profile < ApplicationRecord
  belongs_to :user
  validates :company, :siret_number, uniqueness: true
end
