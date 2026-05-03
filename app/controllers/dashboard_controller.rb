# frozen_string_literal: true

class DashboardController < ApplicationController
  def show
    authorize :dashboard, :show?, policy_class: DashboardPolicy
    authorize Transport::Bus, :index? if current_user.teacher?
    @sections_today = sections_for_teacher
    @buses_today = buses_for_teacher
  end

  private

  def sections_for_teacher
    return [] unless current_user.teacher?

    Section.joins(:teacher_assignments).where(
      teacher_assignments: { user_id: current_user.id, role: TeacherAssignment.roles[:class_teacher] }
    ).distinct.includes(:school_class, :academic_year)
  end

  def buses_for_teacher
    return Transport::Bus.none unless current_user.teacher?

    policy_scope(Transport::Bus)
  end
end
