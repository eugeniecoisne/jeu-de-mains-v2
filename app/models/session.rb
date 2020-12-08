class Session < ApplicationRecord
  belongs_to :workshop
  has_many :bookings, dependent: :destroy
  has_many :reviews, through: :bookings
  has_many :infomessages, dependent: :destroy

  validates :date, :start_at, presence: true, allow_blank: false

  STARTS_AT = [
              '06h00', '06h15', '06h30', '06h45',
              '07h00', '07h15', '07h30', '07h45',
              '08h00', '08h15', '08h30', '08h45',
              '09h00', '09h15', '09h30', '09h45',
              '10h00', '10h15', '10h30', '10h45',
              '11h00', '11h15', '11h30', '11h45',
              '12h00', '12h15', '12h30', '12h45',
              '13h00', '13h15', '13h30', '13h45',
              '14h00', '14h15', '14h30', '14h45',
              '15h00', '15h15', '15h30', '15h45',
              '16h00', '16h15', '16h30', '16h45',
              '17h00', '17h15', '17h30', '17h45',
              '18h00', '18h15', '18h30', '18h45',
              '19h00', '19h15', '19h30', '19h45',
              '20h00', '20h15', '20h30', '20h45',
              '21h00', '21h15', '21h30', '21h45',
              '22h00', '22h15', '22h30', '22h45',
            ]

  MOMENTS = ["Matin", "Après-midi", "Fin de journée"]

  def available
    counter = 0
    bookings.where(db_status: true).each do |booking|
      counter += booking.quantity
    end
    capacity - counter
  end

  def sold
    counter = 0
    bookings.where(db_status: true).each do |booking|
      counter += booking.quantity
    end
    counter
  end

  def moment
    if ['06h00', '06h15', '06h30', '06h45',
        '07h00', '07h15', '07h30', '07h45',
        '08h00', '08h15', '08h30', '08h45',
        '09h00', '09h15', '09h30', '09h45',
        '10h00', '10h15', '10h30', '10h45',
        '11h00', '11h15', '11h30', '11h45'].include?(start_at)
        "Matin"
    elsif ['12h00', '12h15', '12h30', '12h45',
            '13h00', '13h15', '13h30', '13h45',
            '14h00', '14h15', '14h30', '14h45',
            '15h00', '15h15', '15h30', '15h45',
            '16h00', '16h15', '16h30', '16h45',
            '17h00', '17h15'].include?(start_at)
        "Après-midi"
    else
      "Fin de journée"
    end
  end

end
