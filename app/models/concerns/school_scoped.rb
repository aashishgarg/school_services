# frozen_string_literal: true

module SchoolScoped
  extend ActiveSupport::Concern

  included do
    belongs_to :school
    validates :school_id, presence: true

    default_scope -> {
      if Current.school
        where(school_id: Current.school.id)
      else
        all
      end
    }
  end

  class_methods do
    def unscoped_all_schools
      unscope(where: :school_id)
    end
  end
end
