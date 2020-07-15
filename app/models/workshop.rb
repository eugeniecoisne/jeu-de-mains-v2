class Workshop < ApplicationRecord
  has_many_attached :photos
  belongs_to :place
  has_many :sessions, dependent: :destroy
  has_many :animators, dependent: :destroy
  has_many :bookings, through: :sessions, dependent: :destroy
  has_many :reviews, through: :sessions

  validates :title, presence: true, allow_blank: false
  validates :thematic, inclusion: { in: ['Autour du fil', 'Végétal', 'Papier & Lettering', 'Céramique & Modelage', 'Bijoux', 'Cosmétique & Entretien', 'Dessin & peinture', 'Meuble & Décoration'] }
  validates :level, inclusion: { in: ['Débutant', 'Intermédiaire', 'Avancé'] }
  validates :recommendable, inclusion: { in: [1, 2, 3] }

  THEMATICS = ['Autour du fil', 'Végétal', 'Papier & Lettering', 'Céramique & Modelage', 'Bijoux', 'Cosmétique & Entretien', 'Dessin & peinture', 'Meuble & Décoration']

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
    sessions.each { |s| dates << s.date }
    dates
  end

  def rating
    ratings = []
    @average = 0
    if reviews.present?
      reviews.each { |review| ratings << review.rating }
      @average = ratings.sum.fdiv(reviews.count).round(2)
    end
  end

end
