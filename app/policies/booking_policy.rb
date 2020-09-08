class BookingPolicy < ApplicationPolicy

  def create?
    user
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
