class ReviewPolicy < ApplicationPolicy

  def index?
    true
  end

  def new?
    user.bookings.where(status: "paid").count > 0 || user.admin?
  end

  def create?
    new?
  end

  def destroy?
    record.user == user || user.admin?
  end

  def report_review?
    record.booking.session.workshop.place.user == user || user.admin? || (record.booking.session.workshop.animators.last.user == user if record.workshop.animators.present?)
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
