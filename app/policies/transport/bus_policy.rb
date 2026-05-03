# frozen_string_literal: true

module Transport
  class BusPolicy < ApplicationPolicy
    def index?
      user.present?
    end

    def show?
      admin? && same_school?
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
        rel = scope.where(school_id: user.school_id)
        return rel if user.admin?
        return rel if user.school.any_teacher_can_mark_bus?

        rel.where(in_charge_user_id: user.id)
      end
    end
  end
end
