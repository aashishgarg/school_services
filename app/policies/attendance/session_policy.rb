# frozen_string_literal: true

module Attendance
  class SessionPolicy < ApplicationPolicy
    def index?
      user.present?
    end

    def show?
      allowed_for_session?
    end

    def new?
      user.present? && (user.admin? || user.teacher?)
    end

    def create?
      return false unless user && record.is_a?(Attendance::Session)

      user.admin? && record.school_id == user.school_id ||
        user.teacher_assignments.exists?(section_id: record.section_id, role: :class_teacher)
    end

    def edit?
      allowed_for_session?
    end

    def update?
      allowed_for_session?
    end

    class Scope < ApplicationPolicy::Scope
      def resolve
        scope.where(school_id: user.school_id)
      end
    end

    private

    def allowed_for_session?
      return false unless user && record.is_a?(Attendance::Session)

      user.admin? && record.school_id == user.school_id ||
        user.teacher_assignments.exists?(section_id: record.section_id, role: :class_teacher)
    end
  end
end
