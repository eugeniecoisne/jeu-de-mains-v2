class Session < ApplicationRecord
  belongs_to :workshop
  has_many :bookings, dependent: :destroy
  has_many :reviews, through: :bookings

  validates :date, :start_at, presence: true, allow_blank: false

  def available
    counter = 0
    bookings.select { |booking| booking.db_status != 'inactif' }.each do |booking|
      counter += booking.quantity
    end
    capacity - counter
  end

end
