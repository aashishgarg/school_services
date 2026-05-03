# frozen_string_literal: true

module Attendance
  class Session < ApplicationRecord
    include SchoolScoped
    include Auditable

    self.table_name = "attendance_sessions"

    belongs_to :section
    belongs_to :taken_by, class_name: "User", optional: true
    has_many :attendance_records, class_name: "Attendance::Record", foreign_key: :attendance_session_id,
      inverse_of: :attendance_session, dependent: :destroy
    has_many :students, through: :attendance_records

    enum :half, { first: 0, second: 1 }

    validates :on_date, presence: true
    validates :half, presence: true
    validates :section_id, uniqueness: { scope: [ :on_date, :half ] }
  end
end
