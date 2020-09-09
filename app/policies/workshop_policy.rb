class WorkshopPolicy < ApplicationPolicy

  def index?
    true
  end

  def show?
    true
  end

  def create?
    user.profile.role == 'organisateur' || user.admin?
  end

  def new?
    create?
  end

  def update?
    record.place.user == user || user.admin? || record.animators.first.user == user
  end

  def edit?
    update?
  end

  def confirmation?
    update?
  end

  def destroy?
    record.place.user == user || user.admin?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
