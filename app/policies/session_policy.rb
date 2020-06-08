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

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
