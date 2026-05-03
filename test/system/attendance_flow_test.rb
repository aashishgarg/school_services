# frozen_string_literal: true

require "application_system_test_case"

class AttendanceFlowTest < ApplicationSystemTestCase
  test "teacher takes first half attendance for all students" do
    teacher = users(:teacher)
    section = sections(:one)

    travel_to Time.zone.parse("2026-01-15 10:00:00") do
      visit new_session_path
      fill_in "email_address", with: teacher.email_address
      fill_in "password", with: "password"
      click_on "Sign in"

      visit attendance_section_halves_path(section)
      first(:link, "Take").click

      assert_text "Mark attendance"
      click_on "Submit"

      assert_text "Attendance saved"
    end

    session = Attendance::Session.find_by(section_id: section.id, half: :first)
    assert session
    assert_equal 5, session.attendance_records.count
  end
end
