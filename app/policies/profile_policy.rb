class ProfilePolicy < ApplicationPolicy

  def index?
    user
  end

  def show?
    user
  end

  def update?
    record.user == user || user.admin?
  end

  def edit?
    update?
  end

  def dashboard?
    update?
  end

  def chat?
    update?
  end

  def public?
    true
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
