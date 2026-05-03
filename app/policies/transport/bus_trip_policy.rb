# frozen_string_literal: true

module Transport
  class BusTripPolicy < ApplicationPolicy
    def index?
      user.present?
    end

    def show?
      can_manage_trip?
    end

    def create?
      can_manage_trip?
    end

    def complete?
      can_manage_trip?
    end

    class Scope < ApplicationPolicy::Scope
      def resolve
        rel = scope.where(school_id: user.school_id)
        return rel if user.admin?

        if user.school.any_teacher_can_mark_bus?
          rel
        else
          rel.joins(:bus).where(buses: { in_charge_user_id: user.id })
        end
      end
    end

    private

    def can_manage_trip?
      return false unless user && record.is_a?(Transport::BusTrip)

      bus = if record.association(:bus).loaded?
        record.bus
      else
        Transport::Bus.find_by(id: record.bus_id)
      end
      return false unless bus

      return true if user.admin? && bus.school_id == user.school_id
      return true if bus.in_charge_user_id == user.id
      return true if user.school.any_teacher_can_mark_bus?

      false
    end
  end
end
