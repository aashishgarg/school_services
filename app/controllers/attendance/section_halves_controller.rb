# frozen_string_literal: true

module Attendance
  class SectionHalvesController < ApplicationController
    def show
      @section = policy_scope(Section).find(params[:section_id])
      authorize @section, :show?
      @date = Date.current
      @first = Attendance::Session.where(school_id: Current.school.id).find_by(section: @section, on_date: @date, half: :first)
      @second = Attendance::Session.where(school_id: Current.school.id).find_by(section: @section, on_date: @date, half: :second)
    end
  end
end
