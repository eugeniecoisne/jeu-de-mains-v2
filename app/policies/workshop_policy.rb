class WorkshopPolicy < ApplicationPolicy

  def index?
    true
  end

  def show?
    true
  end

  def create?
    user.profile.role.present? || user.admin?
  end

  def new?
    create?
  end

  def update?
    record.place.user == user || user.admin? || record.animators.first.user == user
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

  def destroy?
    record.place.user == user || user.admin?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
