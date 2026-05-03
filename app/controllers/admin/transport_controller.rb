# frozen_string_literal: true

module Admin
  class TransportController < BaseController
    def index
      @date = params[:date].present? ? Date.parse(params[:date]) : Date.current
      @trips = policy_scope(Transport::BusTrip).where(on_date: @date).includes(:bus, bus_stop_progresses: :bus_stop)
    end
  end
end
