# frozen_string_literal: true

require "application_system_test_case"

class TransportFlowTest < ApplicationSystemTestCase
  test "in charge teacher marks stops and completes trip" do
    teacher = users(:teacher)
    bus = buses(:one)

    travel_to Time.zone.parse("2026-01-15 10:00:00") do
      visit new_session_path
      fill_in "email_address", with: teacher.email_address
      fill_in "password", with: "password"
      click_on "Sign in"

      visit root_path
      click_on "Open trip / stops"

      assert_text bus.name
      first(:button, "Reached").click

      assert_text(/reached/i, wait: 10)
    end

    trip = Transport::BusTrip.find_by(bus_id: bus.id, on_date: Date.new(2026, 1, 15))
    assert trip
    assert trip.bus_stop_progresses.where(status: :reached).any?
  end
end
