class InfomessagePolicy < ApplicationPolicy

  def create?
    user
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
