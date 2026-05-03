# frozen_string_literal: true

class AuditPolicy < ApplicationPolicy
  def index?
    admin?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(school_id: user.school_id)
    end
  end
end
