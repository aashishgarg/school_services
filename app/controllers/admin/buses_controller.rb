# frozen_string_literal: true

module Admin
  class BusesController < BaseController
    before_action :set_bus, only: %i[ show edit update destroy ]

    def index
      authorize Transport::Bus
      @buses = policy_scope(Transport::Bus).includes(:in_charge_user)
    end

    def show
      authorize @bus
    end

    def new
      @bus = Transport::Bus.new(school: Current.school)
      authorize @bus
      @teachers = policy_scope(User).where(role: :teacher)
    end

    def create
      @bus = Transport::Bus.new(bus_params.merge(school: Current.school))
      authorize @bus
      if @bus.save
        redirect_to admin_buses_path, notice: "Bus created."
      else
        @teachers = policy_scope(User).where(role: :teacher)
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      authorize @bus
      @teachers = policy_scope(User).where(role: :teacher)
    end

    def update
      authorize @bus
      if @bus.update(bus_params)
        redirect_to admin_buses_path, notice: "Updated."
      else
        @teachers = policy_scope(User).where(role: :teacher)
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      authorize @bus
      @bus.destroy!
      redirect_to admin_buses_path, notice: "Deleted."
    end

    private

    def set_bus
      @bus = policy_scope(Transport::Bus).find(params[:id])
    end

    def bus_params
      params.require(:transport_bus).permit(:name, :plate_no, :capacity, :in_charge_user_id)
    end
  end
end
