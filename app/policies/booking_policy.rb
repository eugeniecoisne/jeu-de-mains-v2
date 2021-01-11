class BookingPolicy < ApplicationPolicy

  def create?
    user
  end

  def update?
    record.user == user || user.admin?
  end

  def options?
    record.user == user || user.admin?
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
