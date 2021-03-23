class BookingPolicy < ApplicationPolicy

  def create?
    user
  end

  def update?
    record.user == user || record.session.workshop.place.user == user || user.admin?
  end

  def show?
    record.session.workshop.place.user == user || user.admin?
  end

  def coordonnees?
    record.user == user || user.admin?
  end

  def options?
    record.user == user || user.admin?
  end

  def payment_success?
    record.user == user || record.session.workshop.place.user == user || user.admin?
  end

  def payment_error?
    record.user == user || user.admin?
  end

  def refund_invoice?
    record.user == user || record.session.workshop.place.user == user || user.admin?
  end

  def cancel?
    record.user == user || record.session.workshop.place.user == user || user.admin?
  end

  def destroy?
    record.user == user || record.session.workshop.place.user == user || user.admin?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
