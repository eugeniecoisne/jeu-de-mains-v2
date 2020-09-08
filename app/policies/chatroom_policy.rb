class ChatroomPolicy < ApplicationPolicy

  def show?
    User.find(record.user1) == user || User.find(record.user2) == user
  end

  def create?
    user
  end

  def update?
    User.find(record.user1) == user || User.find(record.user2) == user
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
