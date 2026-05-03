# frozen_string_literal: true

module Transport
  class BusTrip < ApplicationRecord
    include SchoolScoped
    include Auditable

    self.table_name = "bus_trips"

    belongs_to :bus, class_name: "Transport::Bus"
    has_many :bus_stop_progresses, class_name: "Transport::BusStopProgress", foreign_key: :bus_trip_id,
      inverse_of: :bus_trip, dependent: :destroy

    enum :shift, { morning: 0, evening: 1 }

    validates :on_date, presence: true
    validates :bus_id, uniqueness: { scope: [ :on_date, :shift ] }

    after_create :seed_stop_progresses

    def all_stops_resolved?
      bus_stop_progresses.where(status: :pending).none?
    end

    private

    def seed_stop_progresses
      bus.bus_stops.by_position.each do |stop|
        bus_stop_progresses.create!(school_id: school_id, bus_stop_id: stop.id, status: :pending)
      end
    end
  end
end
