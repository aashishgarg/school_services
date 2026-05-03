# frozen_string_literal: true

class Student < ApplicationRecord
  include SchoolScoped

  belongs_to :section
  belongs_to :bus, class_name: "Transport::Bus", optional: true
  belongs_to :bus_stop, class_name: "Transport::BusStop", optional: true
  has_many :attendance_records, class_name: "Attendance::Record", dependent: :destroy

  validates :admission_no, presence: true, uniqueness: { scope: :school_id }
  validates :full_name, presence: true
end
