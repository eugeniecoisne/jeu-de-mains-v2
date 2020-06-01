class Review < ApplicationRecord
  belongs_to :user
  belongs_to :booking

  validates :rating, inclusion: { in: [0, 1, 2, 3, 4, 5] }
  validates :content, length: { minimum: 20 }, allow_blank: false
end
