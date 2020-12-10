class User < ApplicationRecord
  has_one :profile, dependent: :destroy
  has_many :bookings, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :places, dependent: :destroy
  has_many :animators, dependent: :destroy
  has_many :messages
  has_many :giftcards
  after_create :create_profile
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable,
         :omniauthable, omniauth_providers: %i[facebook google_oauth2]

  def after_confirmation
    send_welcome_email
    super
  end

  def destroy
    update_attributes(db_status: false)
  end

  def active_for_authentication?
      super && !(db_status == false)
  end

  def self.from_omniauth(auth)
    name_split = auth.info.name.split(" ")
    user = User.where(email: auth.info.email).first
    user ||= User.create!(provider: auth.provider, uid: auth.uid, last_name: name_split[-1], first_name: name_split[0], email: auth.info.email, password: Devise.friendly_token[0, 20])
      user
  end

  def fullname
    "#{last_name} #{first_name}"
  end

  private

  def send_welcome_email
    UserMailer.with(user: self).welcome.deliver_later
  end

  def create_profile
    @user = User.last
    @profile = Profile.new
    @profile.user = @user
    @profile.save
  end
end
