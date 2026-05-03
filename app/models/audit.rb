# frozen_string_literal: true

class Audit < ApplicationRecord
  include SchoolScoped

  belongs_to :user, optional: true

  validates :action, :auditable_type, :auditable_id, presence: true
end
