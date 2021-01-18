class GiftcardPolicy < ApplicationPolicy

  def new?
    true
  end

  def update?
    user
  end

  def create?
    user
  end

  def confirmation_enregistrement?
    record.user == user || user.admin?
  end

  def confirmation_achat?
    record.user == user || user.admin?
  end

  def erreur_achat?
    record.user == user || user.admin?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
