class Profile < ApplicationRecord
  has_one_attached :photo
  belongs_to :user
  # validates :company, :siret_number, uniqueness: true


  def self.cities
    Profile.all.where(role: 'animateur').map { |profile| profile.city.capitalize }.uniq
  end

  def thematics
    user.animators.map { |animator| animator.workshop.thematic }.uniq
  end

  def rating
    ratings = []
    reviews_count = 0
    @average = 0
    user.animators.each do |animator|
      if animator.workshop.reviews.present?
        animator.workshop.reviews.each do |review|
          ratings << review.rating
          reviews_count += 1
        end
      end
    end
    @average = ratings.sum.fdiv(reviews_count).round(2)
  end

end
