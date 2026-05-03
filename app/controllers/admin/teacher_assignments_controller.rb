# frozen_string_literal: true

module Admin
  class TeacherAssignmentsController < BaseController
    before_action :set_section

    def create
      @assignment = @section.teacher_assignments.build(assignment_params.merge(school: Current.school))
      authorize @assignment
      if @assignment.save
        redirect_to edit_admin_section_path(@section), notice: "Teacher assigned."
      else
        redirect_to edit_admin_section_path(@section), alert: @assignment.errors.full_messages.to_sentence
      end
    end

    def destroy
      @assignment = @section.teacher_assignments.find(params[:id])
      authorize @assignment
      @assignment.destroy!
      redirect_to edit_admin_section_path(@section), notice: "Assignment removed."
    end

    private

    def set_section
      @section = policy_scope(Section).find(params[:section_id])
    end

    def assignment_params
      params.require(:teacher_assignment).permit(:user_id, :role)
    end
  end
end
