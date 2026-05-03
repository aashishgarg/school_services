# frozen_string_literal: true

require "csv"

module Admin
  class AttendanceExportsController < BaseController
    def show
      start_on = params[:start_on].present? ? Date.parse(params[:start_on]) : Date.current.beginning_of_month
      end_on = params[:end_on].present? ? Date.parse(params[:end_on]) : Date.current.end_of_month

      self.response.headers["Content-Type"] = "text/csv"
      self.response.headers["Content-Disposition"] = %(attachment; filename="attendance-#{start_on}-#{end_on}.csv")

      self.response_body = Enumerator.new do |yielder|
        yielder << CSV.generate_line(%w[date section_id section_name admission_no student_name half status])
        (start_on..end_on).each do |day|
          Attendance::Session.where(school_id: Current.school.id, on_date: day).includes(:section, attendance_records: :student).find_each do |sess|
            sess.attendance_records.includes(:student).find_each do |rec|
              yielder << CSV.generate_line(
                [
                  day,
                  sess.section_id,
                  sess.section.display_name,
                  rec.student.admission_no,
                  rec.student.full_name,
                  sess.half,
                  rec.status
                ]
              )
            end
          end
        end
      end
    end
  end
end
