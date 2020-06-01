class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :session
  has_many :reviews, dependent: :destroy

  validates :quantity, presence: true, allow_blank: false
end
