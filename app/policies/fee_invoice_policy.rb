class FeeInvoicePolicy < ApplicationPolicy

  def create?
    true
  end

  def destroy?
    user.admin?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
