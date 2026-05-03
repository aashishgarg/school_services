# frozen_string_literal: true

class Section < ApplicationRecord
  include SchoolScoped

  belongs_to :school_class
  belongs_to :academic_year
  belongs_to :class_teacher, class_name: "User", optional: true
  has_many :students, dependent: :restrict_with_error
  has_many :teacher_assignments, dependent: :destroy
  has_many :teachers, through: :teacher_assignments, source: :user
  has_many :attendance_sessions, class_name: "Attendance::Session", dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: [ :school_class_id, :academic_year_id ] }

  def display_name
    "#{school_class.name} #{name}"
  end
end
