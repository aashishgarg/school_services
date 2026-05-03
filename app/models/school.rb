# frozen_string_literal: true

class School < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :academic_years, dependent: :destroy
  has_many :school_classes, dependent: :destroy
  has_many :sections, dependent: :destroy
  has_many :students, dependent: :destroy
  has_many :teacher_assignments, dependent: :destroy
  has_many :attendance_sessions, dependent: :destroy
  has_many :attendance_records, dependent: :destroy
  has_many :buses, class_name: "Transport::Bus", dependent: :destroy
  has_many :bus_stops, class_name: "Transport::BusStop", dependent: :destroy
  has_many :bus_trips, class_name: "Transport::BusTrip", dependent: :destroy
  has_many :bus_stop_progresses, class_name: "Transport::BusStopProgress", dependent: :destroy
  has_many :audits, dependent: :destroy

  validates :name, :slug, :time_zone, presence: true
  validates :slug, uniqueness: true

  def any_teacher_can_mark_bus?
    settings.fetch("any_teacher_can_mark_bus", false)
  end

  def attendance_halves_enabled?
    settings.fetch("attendance_halves_enabled", true)
  end

  def current_academic_year
    academic_years.find_by(current: true)
  end
end
