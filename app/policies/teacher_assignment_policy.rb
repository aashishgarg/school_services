# frozen_string_literal: true

class TeacherAssignmentPolicy < ApplicationPolicy
  def create?
    admin?
  end

  def destroy?
    admin? && record.school_id == user.school_id
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(school_id: user.school_id)
    end
  end
end
