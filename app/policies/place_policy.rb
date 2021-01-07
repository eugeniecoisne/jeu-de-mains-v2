class PlacePolicy < ApplicationPolicy

  def create?
    user.profile.role.present? || user.admin?
  end

  def new?
    create?
  end

  def update?
    record.user == user || user.admin?
  end

  def edit?
    update?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
