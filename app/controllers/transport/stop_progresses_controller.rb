# frozen_string_literal: true

module Transport
  class StopProgressesController < ApplicationController
    def update
      @trip = policy_scope(Transport::BusTrip).find(params[:trip_id])
      @progress = @trip.bus_stop_progresses.find(params[:id])
      authorize @progress, :update?
      @progress.update!(
        status: progress_params[:status],
        recorded_at: Time.current,
        recorded_by: current_user,
        note: progress_params[:note]
      )
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to transport_trip_path(@trip) }
      end
    end

    private

    def progress_params
      if params[:transport_bus_stop_progress].present?
        params.require(:transport_bus_stop_progress).permit(:status, :note)
      else
        params.permit(:status, :note)
      end
    end
  end
end
