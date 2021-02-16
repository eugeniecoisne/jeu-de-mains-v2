class ProfilePolicy < ApplicationPolicy

  def index?
    user.profile.role.present? || user.admin?
  end

  def show?
    update?
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

  def send_finalisation_partner_email?
    user.admin?
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
