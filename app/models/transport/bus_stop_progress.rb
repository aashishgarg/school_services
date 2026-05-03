# frozen_string_literal: true

module Transport
  class BusStopProgress < ApplicationRecord
    include SchoolScoped
    include Auditable

    self.table_name = "bus_stop_progresses"

    belongs_to :bus_trip, class_name: "Transport::BusTrip"
    belongs_to :bus_stop, class_name: "Transport::BusStop"
    belongs_to :recorded_by, class_name: "User", optional: true

    enum :status, { pending: 0, reached: 1, skipped: 2 }

    validates :bus_stop_id, uniqueness: { scope: :bus_trip_id }

    after_update_commit :broadcast_admin_transport, if: :saved_change_to_status?

    private

    def broadcast_admin_transport
      return unless school_id

      Turbo::StreamsChannel.broadcast_replace_to(
        "admin_transport_#{school_id}_#{on_date_for_broadcast}",
        target: ActionView::RecordIdentifier.dom_id(bus_trip.reload),
        partial: "admin/transport/trip_row",
        locals: { trip: bus_trip }
      )
    end

    def on_date_for_broadcast
      bus_trip.on_date.to_s
    end
  end
end
