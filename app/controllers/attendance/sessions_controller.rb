# frozen_string_literal: true

module Attendance
  class SessionsController < ApplicationController
    before_action :set_session, only: %i[ show edit update ]

    def index
      authorize Attendance::Session
      @sessions = policy_scope(Attendance::Session).order(on_date: :desc, created_at: :desc).limit(50)
    end

    def new
      @section = policy_scope(Section).find(params[:section_id])
      authorize @section, :show?
      @half = normalized_half_param
      existing = Attendance::Session.find_by(section: @section, on_date: Date.current, half: @half)
      if existing
        redirect_to edit_attendance_session_path(existing)
        return
      end
      @students = @section.students.order(:full_name)
      @session = Attendance::Session.new(section: @section, school: Current.school, on_date: Date.current, half: @half)
      authorize @session, :new?
    end

    def create
      @section = policy_scope(Section).find(params[:section_id])
      authorize @section, :show?
      @session = Attendance::Session.new(
        school: Current.school,
        section: @section,
        on_date: Date.current,
        half: normalized_half_param,
        taken_by: current_user,
        taken_at: Time.current
      )
      authorize @session, :create?
      Attendance::Session.transaction do
        @session.save!
        create_records!
      end
      redirect_to attendance_session_path(@session), notice: "Attendance saved."
    rescue ActiveRecord::RecordInvalid
      @students = @section.students.order(:full_name)
      @half = @session.half
      render :new, status: :unprocessable_entity
    end

    def show
      authorize @session
    end

    def edit
      authorize @session
      @section = @session.section
      @students = @section.students.order(:full_name)
    end

    def update
      authorize @session
      Attendance::Session.transaction do
        update_records!
        @session.update!(taken_by: current_user, taken_at: Time.current)
      end
      redirect_to attendance_session_path(@session), notice: "Attendance updated."
    rescue ActiveRecord::RecordInvalid
      @section = @session.section
      @students = @section.students.order(:full_name)
      render :edit, status: :unprocessable_entity
    end

    private

    def set_session
      @session = policy_scope(Attendance::Session).find(params[:id])
    end

    def normalized_half_param
      h = params[:half].presence || "first"
      h = "first" unless Current.school.attendance_halves_enabled?
      Attendance::Session.halves.key?(h) ? h : "first"
    end

    def create_records!
      statuses = params[:statuses].presence || {}
      @section.students.each do |st|
        raw = statuses[st.id.to_s] || statuses[st.id] || "present"
        status = Attendance::Record.statuses.key?(raw.to_s) ? raw.to_s : "present" # enum string keys
        @session.attendance_records.create!(school_id: Current.school.id, student: st, status: status)
      end
    end

    def update_records!
      statuses = params[:statuses].presence || {}
      @session.attendance_records.each do |rec|
        raw = statuses[rec.student_id.to_s] || statuses[rec.student_id]
        next if raw.blank?

        status = Attendance::Record.statuses.key?(raw.to_s) ? raw.to_s : rec.status.to_s
        rec.update!(status: status)
      end
    end
  end
end
