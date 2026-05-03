# frozen_string_literal: true

class TeacherAssignment < ApplicationRecord
  include SchoolScoped

  belongs_to :user
  belongs_to :section

  enum :role, { class_teacher: 0, subject_teacher: 1 }

  validates :user_id, uniqueness: { scope: [ :section_id, :role ] }
end
