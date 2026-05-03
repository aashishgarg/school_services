# frozen_string_literal: true

class SchoolClassPolicy < ApplicationPolicy
  def index?
    admin?
  end

  def show?
    admin? && same_school?
  end

  def create?
    admin?
  end

  def update?
    admin? && same_school?
  end

  def destroy?
    admin? && same_school?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(school_id: user.school_id)
    end
  end
end
