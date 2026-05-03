# frozen_string_literal: true

module Admin
  class AttendanceController < BaseController
    def index
      @date = params[:date].present? ? Date.parse(params[:date]) : Date.current
      @sections = policy_scope(Section).includes(:school_class, :academic_year, :students)
      @stats = Attendance::DailyReport.new(school: Current.school, date: @date, sections: @sections).rows
    end
  end
end
