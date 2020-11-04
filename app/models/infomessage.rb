class Infomessage < ApplicationRecord
  belongs_to :session

  validates :content, presence: true, allow_blank: false
end
