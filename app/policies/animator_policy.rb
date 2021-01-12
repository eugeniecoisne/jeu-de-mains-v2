class AnimatorPolicy < ApplicationPolicy

  def create?
    user || user.admin?
  end

  def new?
    create?
  end

  def update?
    record.workshop.place.user == user || user.admin?
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
