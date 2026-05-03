# frozen_string_literal: true

class SchoolPolicy < ApplicationPolicy
  def show?
    admin? && record.id == user.school_id
  end

  def update?
    admin? && record.id == user.school_id
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(id: user.school_id)
    end
  end
end
