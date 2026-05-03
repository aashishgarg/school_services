# frozen_string_literal: true

module Admin
  class StudentsController < BaseController
    before_action :set_student, only: %i[ show edit update destroy ]

    def index
      authorize Student
      @students = policy_scope(Student).includes(:section)
      @students = @students.where("full_name ILIKE ? OR admission_no ILIKE ?", "%#{params[:q]}%", "%#{params[:q]}%") if params[:q].present?
      @students = @students.where(section_id: params[:section_id]) if params[:section_id].present?
    end

    def show
      authorize @student
    end

    def new
      @student = Student.new(school: Current.school)
      authorize @student
      @sections = policy_scope(Section).includes(:school_class, :academic_year)
    end

    def create
      @student = Student.new(student_params.merge(school: Current.school))
      authorize @student
      if @student.save
        redirect_to admin_students_path, notice: "Student created."
      else
        @sections = policy_scope(Section).includes(:school_class, :academic_year)
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      authorize @student
      @sections = policy_scope(Section).includes(:school_class, :academic_year)
    end

    def update
      authorize @student
      if @student.update(student_params)
        redirect_to admin_students_path, notice: "Updated."
      else
        @sections = policy_scope(Section).includes(:school_class, :academic_year)
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      authorize @student
      @student.destroy!
      redirect_to admin_students_path, notice: "Deleted."
    end

    def import
      authorize Student, :import?
      result = Admin::StudentCsvImporter.new(school: Current.school, csv_io: params[:csv]).call
      redirect_to admin_students_path, notice: "Imported #{result[:created]} students. #{result[:errors].size} errors."
    end

    private

    def set_student
      @student = policy_scope(Student).find(params[:id])
    end

    def student_params
      params.require(:student).permit(:section_id, :admission_no, :full_name, :gender, :dob, :guardian_name, :guardian_phone, :bus_id, :bus_stop_id)
    end
  end
end
