# frozen_string_literal: true

class SectionPolicy < ApplicationPolicy
  def index?
    admin?
  end

  def show?
    return false unless record.is_a?(Section)

    (admin? && record.school_id == user.school_id) || teacher_class_teacher_for_section?
  end

  def create?
    admin?
  end

  def update?
    admin? && same_school?
  end

  def destroy?
    admin? && same_school?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(school_id: user.school_id)
    end
  end

  private

  def teacher_class_teacher_for_section?
    return false unless user&.teacher?

    user.teacher_assignments.exists?(section_id: record.id, role: :class_teacher)
  end
end
