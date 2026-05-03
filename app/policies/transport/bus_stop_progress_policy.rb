# frozen_string_literal: true

module Transport
  class BusStopProgressPolicy < ApplicationPolicy
    def update?
      return false unless user && record.is_a?(Transport::BusStopProgress)

      trip = record.bus_trip
      return true if user.admin? && trip.school_id == user.school_id

      bus = trip.bus
      return true if bus.in_charge_user_id == user.id
      return true if user.school.any_teacher_can_mark_bus?

      false
    end

    class Scope < ApplicationPolicy::Scope
      def resolve
        scope.where(school_id: user.school_id)
      end
    end
  end
end
