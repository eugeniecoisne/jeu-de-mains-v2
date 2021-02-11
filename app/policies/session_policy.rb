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
    record.workshop.place.user == user || user.admin? || (record.workshop.animators.last.user if record.workshop.animators.present?)
  end

  def destroy?
    index?
  end

  def annulation_et_remboursement?
    index?
  end

  def participants?
    index?
  end

  def send_visio_information?
    index?
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
