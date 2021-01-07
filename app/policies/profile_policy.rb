class ProfilePolicy < ApplicationPolicy

  def index?
    user
  end

  def show?
    record.user == user || user.admin?
  end

  def update?
    record.user == user || user.admin?
  end

  def edit?
    update?
  end

  def tableau_de_bord?
    update?
  end

  def messagerie?
    update?
  end

  def mes_cartes_cadeaux?
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
