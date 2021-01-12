class InfomessagePolicy < ApplicationPolicy

  def create?
    user.profile.role.present? || user.admin?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
