class User < ApplicationRecord
  has_one :profile, dependent: :destroy
  has_many :bookings, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :places, dependent: :destroy
  has_many :animators, dependent: :destroy
  has_many :messages
  after_create :create_profile
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  def after_confirmation
    if @user.created_at > Date.today - 1
      send_welcome_email
      super
    end
  end

  private

  def send_welcome_email
    UserMailer.with(user: self).welcome.deliver_now
  end

  def create_profile
    @user = User.last
    @profile = Profile.new
    @profile.user = @user
    @profile.save
  end
end
