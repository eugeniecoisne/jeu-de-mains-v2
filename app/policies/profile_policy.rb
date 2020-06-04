class ProfilePolicy < ApplicationPolicy

  def show?
    true
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
