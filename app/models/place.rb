class Place < ApplicationRecord
  has_one_attached :photo
  belongs_to :user
  has_many :workshops, dependent: :destroy
  has_many :sessions, through: :workshops
  has_many :bookings, through: :sessions
  has_many :reviews, through: :sessions

  validates :name, :address, :zip_code, :city, :siret_number, presence: true, allow_blank: false
  validates :name, :siret_number, uniqueness: true

  geocoded_by :full_address
  after_validation :geocode, if: :will_save_change_to_address?

  def self.cities
    cities = []
    Place.all.where(db_status: true).each { |place| cities << place.city.capitalize }
    cities.uniq!
  end

  def rating
    ratings = []
    @average = 0
    if reviews.where(db_status: true).present?
      reviews.where(db_status: true).each { |review| ratings << review.rating }
      @average = ratings.sum.fdiv(reviews.where(db_status: true).count).round(2)
    end
  end

  def thematics
    workshops.map { |workshop| workshop.thematic }.uniq
  end

  private

  def full_address
    "#{address} #{zip_code} #{city}"
  end


end
