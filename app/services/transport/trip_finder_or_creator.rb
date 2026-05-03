# frozen_string_literal: true

module Transport
  class TripFinderOrCreator
    def self.call(bus:, on_date:, shift: nil)
      new(bus: bus, on_date: on_date, shift: shift).call
    end

    def initialize(bus:, on_date:, shift: nil)
      @bus = bus
      @on_date = on_date.to_date
      @shift = shift
    end

    def call
      resolved_shift = @shift || infer_shift
      trip = Transport::BusTrip.find_or_initialize_by(bus_id: @bus.id, on_date: @on_date, shift: resolved_shift)
      if trip.new_record?
        trip.school_id = @bus.school_id
        trip.started_at = Time.current
        trip.save!
      end
      trip
    end

    private

    def infer_shift
      return :morning if @on_date != Date.current

      zone = Time.find_zone!(@bus.school.time_zone)
      zone.now.hour < 12 ? :morning : :evening
    end
  end
end
