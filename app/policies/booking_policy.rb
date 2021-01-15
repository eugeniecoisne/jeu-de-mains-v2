class BookingPolicy < ApplicationPolicy

  def create?
    user
  end

  def update?
    record.user == user || user.admin?
  end

  def options?
    update?
  end

  def payment_success?
    update?
  end

  def payment_error?
    update?
  end

  def destroy?
    create?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
