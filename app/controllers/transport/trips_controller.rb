# frozen_string_literal: true

module Transport
  class TripsController < ApplicationController
    before_action :set_trip, only: %i[ show complete ]

    def index
      authorize Transport::BusTrip
      @trips = policy_scope(Transport::BusTrip).where(on_date: Date.current).includes(:bus)
    end

    def show
      authorize @trip
      @progress_rows = @trip.bus_stop_progresses.includes(:bus_stop).sort_by { |p| [ p.bus_stop.position, p.bus_stop_id ] }
    end

    def create
      bus = policy_scope(Transport::Bus).find(params[:bus_id])
      trip = Transport::TripFinderOrCreator.call(bus: bus, on_date: Date.current)
      authorize trip, :create?
      redirect_to transport_trip_path(trip)
    end

    def complete
      authorize @trip, :complete?
      unless @trip.all_stops_resolved?
        redirect_to transport_trip_path(@trip), alert: "Resolve all stops first."
        return
      end
      @trip.update!(completed_at: Time.current)
      redirect_to transport_trip_path(@trip), notice: "Trip completed."
    end

    private

    def set_trip
      @trip = policy_scope(Transport::BusTrip).find(params[:id])
    end
  end
end
