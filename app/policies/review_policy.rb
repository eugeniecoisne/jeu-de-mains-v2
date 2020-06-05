class ReviewPolicy < ApplicationPolicy

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
