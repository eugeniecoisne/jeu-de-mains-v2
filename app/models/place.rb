class Place < ApplicationRecord
  belongs_to :user
  has_many :workshops, dependent: :destroy

  validates :name, :address, :zip_code, :city, :siret_number, presence: true, allow_blank: false
  validates :name, :siret_number, uniqueness: true
end
