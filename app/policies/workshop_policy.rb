class WorkshopPolicy < ApplicationPolicy

  def index?
    true
  end

  def show?
    true
  end

  def privatisation?
    true
  end

  def privatisation_envoyee?
    true
  end

  def create?
    (user.profile.role.present? && user.can_receive_payments? && user.profile.db_status == true) || user.admin?
  end

  def new?
    create?
  end

  def update?
    (record.place.user == user && user.profile.db_status == true) || user.admin? || (record.animators.where(db_status: true).last.user == user if (record.animators.present? && record.place.user.profile.db_status == true))
  end

  def edit?
    update?
  end

  def finalisation?
    update?
  end

  def send_verification_mail?
    update?
  end

  def confirmation?
    update?
  end

  def mark_as_verified_or_unverified?
    user.admin?
  end

  def invitation?
    update?
  end

  def destroy?
    record.place.user == user || user.admin?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
