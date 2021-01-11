class PaymentPolicy < ApplicationPolicy

  def new?
    record.user == user
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
