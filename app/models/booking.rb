class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :session
  has_many :reviews, dependent: :destroy

  validates :quantity, presence: true, allow_blank: false

  def contact_visio_completed?
    phone_number? && address? && zip_code? && city?
  end

  def contact_completed?
    phone_number?
  end

end
