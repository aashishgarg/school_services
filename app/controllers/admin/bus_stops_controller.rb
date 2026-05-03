# frozen_string_literal: true

module Admin
  class BusStopsController < BaseController
    before_action :set_bus
    before_action :set_stop, only: %i[ edit update destroy ]

    def index
      authorize Transport::BusStop
      @stops = @bus.bus_stops.by_position
    end

    def new
      @stop = @bus.bus_stops.build(school: Current.school)
      authorize @stop
    end

    def create
      @stop = @bus.bus_stops.build(stop_params.merge(school: Current.school))
      authorize @stop
      if @stop.save
        redirect_to admin_bus_bus_stops_path(@bus), notice: "Stop added."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      authorize @stop
    end

    def update
      authorize @stop
      if @stop.update(stop_params)
        redirect_to admin_bus_bus_stops_path(@bus), notice: "Updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      authorize @stop
      @stop.destroy!
      redirect_to admin_bus_bus_stops_path(@bus), notice: "Deleted."
    end

    private

    def set_bus
      @bus = policy_scope(Transport::Bus).find(params[:bus_id])
    end

    def set_stop
      @stop = @bus.bus_stops.find(params[:id])
    end

    def stop_params
      params.require(:transport_bus_stop).permit(:name, :position, :expected_time)
    end
  end
end
