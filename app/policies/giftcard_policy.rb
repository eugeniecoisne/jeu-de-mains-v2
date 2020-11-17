class GiftcardPolicy < ApplicationPolicy

  def new?
    true
  end

  def show?
    record.user == user || user.admin?
  end

  def update?
    record.user == user || user.admin?
  end

  def create?
    user
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
