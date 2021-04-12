class SessionPolicy < ApplicationPolicy

  def create?
    user.profile.role.present? || user.admin?
  end

  def new?
    create?
  end

  def search_places?
    true
  end

  def index?
    user.profile.role.present? || user.admin?
  end

  def destroy?
    participants?
  end

  def annulation_et_remboursement?
    participants?
  end

  def participants?
    (record.workshop.place.user == user && record.workshop.place.user.profile.db_status == true) || user.admin? || (record.workshop.animators.last.user == user if record.workshop.animators.present?)
  end

  def send_visio_information?
    participants?
  end

  def expedition_kits?
    participants?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
