class SessionPolicy < ApplicationPolicy

  def create?
    user.profile.role == 'organisateur' || user.admin?
  end

  def new?
    create?
  end

  def search_places?
    true
  end

  def destroy?
    record.workshop.place.user == user || user.admin?
  end

  def participants?
    record.workshop.place.user == user || user.admin?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
