class Workshop < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  has_many_attached :photos
  belongs_to :place
  has_many :sessions, dependent: :destroy
  has_many :animators, dependent: :destroy
  has_many :bookings, through: :sessions, dependent: :destroy
  has_many :reviews, through: :sessions

  validates :title, presence: true, allow_blank: false
  validates :duration, presence: true, allow_blank: false
  validates :level, inclusion: { in: ['Débutant', 'Intermédiaire', 'Avancé'] }
  validates :recommendable, inclusion: { in: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10] }
  validate :attachments_size

  serialize :thematic, Array

  THEMATICS = ['Autour du fil', 'Végétal', 'Papier & Calligraphie', 'Céramique & Modelage', 'Bijoux', 'Cosmétique & Entretien', 'Peinture & Dessin', 'Meuble & Décoration', 'Travail du cuir']
  LEVELS = ['Débutant', 'Intermédiaire', 'Avancé']
  PRIVATISATION_CAPACITIES = ["2 personnes", "3 personnes", "4 personnes", "5 personnes", "6 personnes", "7 personnes", "8 personnes", "9 personnes", "10 personnes", "11 personnes", "12 personnes", "13 personnes", "14 personnes", "15 personnes", "16 personnes", "17 personnes", "18 personnes", "19 personnes", "20 personnes", "21 personnes", "22 personnes", "23 personnes", "24 personnes", "25 personnes", "Plus de 25 personnes"]

  DURATIONS = {
    "15 minutes" => 15,
    "30 minutes" => 30,
    "45 minutes" => 45,
    "1 heure" => 60,
    "1 heure 15" => 75,
    "1 heure 30" => 90,
    "1 heure 45" => 105,
    "2 heures" => 120,
    "2 heures 15" => 135,
    "2 heures 30" => 150,
    "2 heures 45" => 165,
    "3 heures" => 180,
    "3 heures 15" => 195,
    "3 heures 30" => 210,
    "3 heures 45" => 225,
    "4 heures" => 240,
    "4 heures 15" => 255,
    "4 heures 30" => 270,
    "4 heures 45" => 285,
    "5 heures" => 300,
    "5 heures 15" => 315,
    "5 heures 30" => 330,
    "5 heures 45" => 345,
    "6 heures" => 360,
    "6 heures 15" => 375,
    "6 heures 30" => 390,
    "6 heures 45" => 405,
    "7 heures" => 420,
    "7 heures 15" => 435,
    "7 heures 30" => 450,
    "7 heures 45" => 465,
    "8 heures" => 480,
    "2 jours consécutifs" => 2880,
    "3 jours consécutifs" => 4320,
    "4 jours consécutifs" => 5760,
    "5 jours consécutifs" => 7200
  }

  KIT_SHIPPING = {
    "0 euro TTC" => 0.0,
    "0.50 euro TTC" => 0.5,
    "1.00 euro TTC" => 1.0,
    "1.50 euros TTC" => 1.5,
    "2.00 euros TTC" => 2.0,
    "2.50 euros TTC" => 2.5,
    "3.00 euros TTC" => 3.0,
    "3.50 euros TTC" => 3.5,
    "4.00 euros TTC" => 4.0,
    "4.50 euros TTC" => 4.5,
    "5.00 euros TTC" => 5.0,
    "5.50 euros TTC" => 5.5,
    "6.00 euros TTC" => 6.0,
    "6.50 euros TTC" => 6.5,
    "7.00 euros TTC" => 7.0,
    "7.50 euros TTC" => 7.5,
    "8.00 euro TTC" => 8.0,
    "8.50 euros TTC" => 8.5,
    "9.00 euros TTC" => 9.0,
    "9.50 euros TTC" => 9.5,
    "10.00 euros TTC" => 10.0,
    "10.50 euros TTC" => 10.5,
    "11.00 euros TTC" => 11.0,
    "11.50 euros TTC" => 11.5,
    "12.00 euros TTC" => 12.0,
    "12.50 euros TTC" => 12.5,
    "13.00 euros TTC" => 13.0,
    "13.50 euros TTC" => 13.5,
    "14.00 euros TTC" => 14.0,
    "14.50 euros TTC" => 14.5,
    "15.00 euros TTC" => 15.0
  }

  include PgSearch::Model
    pg_search_scope :global_search,
      against: [ :title, :program, :final_product, :thematic ],
      associated_against: {
        sessions: [ :date ],
        place: [ :zip_code, :city ]
      },
      using: {
        tsearch: { prefix: true }
      }

  def dates
    dates = []
    sessions.where(db_status: true).each { |s| dates << s.start_date }
    dates
  end

  def rating
    ratings = []
    @average = 0
    if reviews.where(db_status: true).present?
      reviews.where(db_status: true).each { |review| ratings << review.rating }
      @average = ratings.sum.fdiv(reviews.where(db_status: true).count).round(2)
    end
  end

  def visio_with_kit?
    visio? && kit?
  end

  def moments
    moments = []
    sessions.where(db_status: true).each { |s| moments << s.moment }
    moments.uniq
  end

  def completed?
    if kit?
      program? && final_product? && title? && capacity? && duration? && thematic? && level? && price? && price > 0 && photos.attached? && kit_shipping_price? && kit_description?
    else
      program? && final_product? && title? && capacity? && duration? && thematic? && level? && price? && price > 0 && photos.attached?
    end
  end

  private

  def attachments_size
    if self.photos.attached?
    size_array = self.photos.collect { |e| e.byte_size }
      if size_array.inject(0, :+) > 15.megabytes
        errors.add(:attachments, "limite de poids max 15 Mo")
      end
    end
  end

end
