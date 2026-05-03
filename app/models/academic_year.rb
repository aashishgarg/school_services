# frozen_string_literal: true

class AcademicYear < ApplicationRecord
  include SchoolScoped

  has_many :sections, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: { scope: :school_id }
  validates :starts_on, :ends_on, presence: true
  validate :ends_after_starts

  before_save :clear_other_current_flags, if: :current?

  private

  def ends_after_starts
    return if starts_on.blank? || ends_on.blank?

    errors.add(:ends_on, "must be after starts on") if ends_on < starts_on
  end

  def clear_other_current_flags
    AcademicYear.unscoped.where(school_id: school_id).where.not(id: id).update_all(current: false)
  end
end
