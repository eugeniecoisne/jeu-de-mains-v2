class Profile < ApplicationRecord

  extend FriendlyId
  friendly_id :company, use: :slugged

  has_one_attached :photo
  belongs_to :user
  validate :attachment_size

  ROLES = ["Boutique / atelier", "Animation d'ateliers", "Organisation d'événements"]


  def self.cities_and_districts
    districts_to_show = []
    big_cities_to_show = []
    Profile.all.where(db_status: true, ready: true).select { |profile| profile.role.present? }.each do |profile|
      if profile.zip_code.first(2) == "97"
        districts_to_show << Place::DISTRICTS[profile.zip_code.first(3)]
      else
        districts_to_show << Place::DISTRICTS[profile.zip_code.first(2)]
      end
      if Place::BIG_CITIES_ZIPCODES.include?(profile.zip_code.first(2))
        big_cities_to_show << Place::BIG_CITIES[profile.zip_code.first(2)]
      end
    end

    districts_to_show = districts_to_show.uniq.sort
    big_cities_to_show = big_cities_to_show.uniq.sort

    if big_cities_to_show.count > 0 && districts_to_show.count > 0
      big_cities_to_show.concat(districts_to_show)
    elsif districts_to_show.count > 0
      districts_to_show
    else
      big_cities_to_show
    end
  end

  def district
    if zip_code.first(2) == "97"
      Place::DISTRICTS[zip_code.first(3)]
    else
      Place::DISTRICTS[zip_code.first(2)]
    end
  end

  def big_city
    if Place::BIG_CITIES_ZIPCODES.include?zip_code.first(2)
      Place::BIG_CITIES[zip_code.first(2)]
    end
  end

  def self.cities
    Profile.all.where(db_status: true, ready: true).select { |profile| profile.role.present? }.map { |profile| profile.city.capitalize }.uniq
  end

  def self.companies
    Profile.all.where(db_status: true, ready: true).select { |profile| profile.role.present? }.map { |profile| profile.company }
  end

  def thematics
    thematics = user.animators.map { |animator| animator.workshop.thematic if animator.workshop.db_status == true }.flatten(1)
    user.places.each do |place|
      place.workshops.where(db_status: true).each do |workshop|
        workshop.thematic.each do |t|
          thematics << t
        end
      end
    end
    thematics.uniq
  end

  def self.thematics
    self_thematics = []
    Profile.all.where(db_status: true, ready: true).each do |p|
      self_thematics.concat(p.thematics)
    end
    self_thematics.uniq
  end

  def self.roles
    self_roles = []
    Profile.all.where(db_status: true, ready: true).each do |p|
      self_roles << p.role if p.role
    end
    self_roles.uniq
  end

  def rating
    ratings = []
    reviews_count = 0
    @average = 0
    if user.animators.count > 0
      user.animators.each do |animator|
        if animator.workshop.reviews.where(db_status: true).count > 0
          animator.workshop.reviews.where(db_status: true).each {|r|
            ratings << r.rating
            reviews_count += 1
          }
        end
      end
    end

    if user.places.select { |place| place.workshops.present? }.each { |place| place.workshops }.count > 0
      user.places.select { |place| place.workshops.present? }.each { |place| place.workshops.each { |workshop|
        if workshop.reviews.where(db_status: true).count > 0
          workshop.reviews.where(db_status: true).each {|r|
            ratings << r.rating
            reviews_count += 1
          }
        end
      }}
    end

    return @average = ratings.sum.fdiv(reviews_count).round(2)
  end

  def reviews
    reviews = []
    if user.animators.count > 0
      user.animators.each do |animator|
        if animator.workshop.reviews.where(db_status: true).count > 0
          animator.workshop.reviews.where(db_status: true).each { |r| reviews << r }
        end
      end
    end
    if user.places.select { |place| place.workshops.present? }.each { |place| place.workshops }.count > 0
      user.places.select { |place| place.workshops.present? }.each { |place| place.workshops.each { |workshop|
        if workshop.reviews.where(db_status: true).count > 0
          workshop.reviews.where(db_status: true).each { |r| reviews << r }
        end
      }}
    end
    return reviews
  end

  def true_and_false_reviews
    true_and_false_reviews = []
    if user.animators.count > 0
      user.animators.each do |animator|
        if animator.workshop.reviews.count > 0
          animator.workshop.reviews.each { |r| true_and_false_reviews << r }
        end
      end
    end
    if user.places.select { |place| place.workshops.present? }.each { |place| place.workshops }.count > 0
      user.places.select { |place| place.workshops.present? }.each { |place| place.workshops.each { |workshop|
        if workshop.reviews.count > 0
          workshop.reviews.each { |r| true_and_false_reviews << r }
        end
      }}
    end
    return true_and_false_reviews
  end

  private

  def attachment_size
    if self.photo.attached?
      photo_size = self.photo.byte_size
      if photo_size > 3.megabytes
        errors.add(:attachments, "limite de poids max 3 Mo")
      end
    end
  end

end
