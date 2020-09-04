class Profile < ApplicationRecord
  has_one_attached :photo
  belongs_to :user
  # validates :company, :siret_number, uniqueness: true


  def self.cities
    Profile.all.where(role: 'animateur', db_status: true).map { |profile| profile.city.capitalize }.uniq
  end

  def self.companies
    Profile.all.where(role: 'animateur', db_status: true).map { |profile| profile.company }
  end

  def thematics
    user.animators.map { |animator| animator.workshop.thematic }.uniq
  end

  def rating
    ratings = []
    reviews_count = 0
    @average = 0
    user.animators.each do |animator|
      if animator.workshop.reviews.where(db_status: true).present?
        animator.workshop.reviews.where(db_status: true).each do |review|
          ratings << review.rating
          reviews_count += 1
        end
      end
    end
    @average = ratings.sum.fdiv(reviews_count).round(2)
  end

end
