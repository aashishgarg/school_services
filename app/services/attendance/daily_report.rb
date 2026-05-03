# frozen_string_literal: true

module Attendance
  class DailyReport
    Row = Struct.new(:section, :student_count, :first_present, :first_absent, :second_present, :second_absent, keyword_init: true)

    def initialize(school:, date:, sections:)
      @school = school
      @date = date
      @sections = sections
    end

    def rows
      @sections.map do |section|
        s1 = Attendance::Session.where(school_id: @school.id).find_by(section_id: section.id, on_date: @date, half: :first)
        s2 = Attendance::Session.where(school_id: @school.id).find_by(section_id: section.id, on_date: @date, half: :second)
        Row.new(
          section: section,
          student_count: section.students.count,
          first_present: s1 ? s1.attendance_records.where(status: :present).count : nil,
          first_absent: s1 ? s1.attendance_records.where.not(status: :present).count : nil,
          second_present: s2 ? s2.attendance_records.where(status: :present).count : nil,
          second_absent: s2 ? s2.attendance_records.where.not(status: :present).count : nil
        )
      end
    end
  end
end
