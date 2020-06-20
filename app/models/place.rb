class Place < ApplicationRecord
  has_one_attached :photo
  belongs_to :user
  has_many :workshops, dependent: :destroy
  has_many :sessions, through: :workshops
  has_many :bookings, through: :sessions

  validates :name, :address, :zip_code, :city, :siret_number, presence: true, allow_blank: false
  validates :name, :siret_number, uniqueness: true

  def self.cities
    cities = []
    Place.all.each { |place| cities << place.city.capitalize }
    cities.uniq!
  end

end
