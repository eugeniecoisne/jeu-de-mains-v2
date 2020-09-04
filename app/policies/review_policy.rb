class ReviewPolicy < ApplicationPolicy

  def index?
    true
  end

  def create?
    user
  end

  def new?
    create?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
