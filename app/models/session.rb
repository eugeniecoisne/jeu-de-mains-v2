class Session < ApplicationRecord
  belongs_to :workshop
  has_many :bookings, dependent: :destroy

  validates :date, :start_at, presence: true, allow_blank: false
end
