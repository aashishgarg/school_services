# frozen_string_literal: true

module Attendance
  class Record < ApplicationRecord
    include SchoolScoped
    include Auditable

    self.table_name = "attendance_records"

    belongs_to :attendance_session, class_name: "Attendance::Session"
    belongs_to :student

    enum :status, { present: 0, absent: 1, late: 2, excused: 3 }, default: :present

    validates :student_id, uniqueness: { scope: :attendance_session_id }
  end
end
