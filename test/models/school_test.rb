# frozen_string_literal: true

require "test_helper"

class SchoolTest < ActiveSupport::TestCase
  test "school is valid with required attributes" do
    school = School.new(name: "Test", slug: "test-school-unique", time_zone: "UTC")
    assert school.valid?
  end
end
