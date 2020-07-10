class Review < ApplicationRecord
  belongs_to :user
  belongs_to :booking

  validates :rating, inclusion: { in: [0, 1, 2, 3, 4, 5] }, presence: :true, allow_blank: false
  validates :content, length: { minimum: 20 }, allow_blank: false, presence: :true
end
