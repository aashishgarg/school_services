# frozen_string_literal: true

class SchoolClass < ApplicationRecord
  include SchoolScoped

  self.table_name = "school_classes"

  has_many :sections, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: { scope: :school_id }

  scope :ordered, -> { order(:position, :name) }
end
