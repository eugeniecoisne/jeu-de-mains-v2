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

end
