class Profile < ApplicationRecord
  has_one_attached :photo
  belongs_to :user
  # validates :company, :siret_number, uniqueness: true
end
