class ProfilePolicy < ApplicationPolicy

  def index?
    (user.profile.role.present? && user.profile.db_status == true) || user.admin?
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

  def transactions?
    update?
  end

  def releve_de_commissions?
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

  def comptabilite_reservations?
    user.admin?
  end

  def comptabilite_cartes_cadeaux?
    user.admin?
  end

  def social_media?
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
