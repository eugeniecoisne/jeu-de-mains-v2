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
  validates :thematic, inclusion: { in: ['Autour du fil', 'Végétal', 'Papier & Lettering', 'Céramique & Modelage', 'Bijou', 'Cosmétique & Entretien', 'Dessin & Peinture', 'Meuble & Décoration', 'Travail du cuir'] }
  validates :level, inclusion: { in: ['Débutant', 'Intermédiaire', 'Avancé'] }
  validates :recommendable, inclusion: { in: [1, 2, 3] }
  validate :attachments_size

  THEMATICS = ['Autour du fil', 'Végétal', 'Papier & Lettering', 'Céramique & Modelage', 'Bijou', 'Cosmétique & Entretien', 'Dessin & Peinture', 'Meuble & Décoration', 'Travail du cuir']
  LEVELS = ['Débutant', 'Intermédiaire', 'Avancé']

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
    sessions.where(db_status: true).each { |s| dates << s.date }
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

  def moments
    moments = []
    sessions.where(db_status: true).each { |s| moments << s.moment }
    moments.uniq
  end

  def completed?
    program? && final_product? && title? && capacity? && duration? && thematic? && level? && price? && ephemeral? && price > 0 && photos.attached?
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
