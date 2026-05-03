# frozen_string_literal: true

module Admin
  class SectionsController < BaseController
    before_action :set_section, only: %i[ show edit update destroy ]

    def index
      authorize Section
      @sections = policy_scope(Section).includes(:school_class, :academic_year, :class_teacher)
    end

    def show
      authorize @section
    end

    def new
      @section = Section.new(school: Current.school)
      authorize @section
      load_form_collections
    end

    def create
      @section = Section.new(section_params.merge(school: Current.school))
      authorize @section
      if @section.save
        redirect_to admin_sections_path, notice: "Section created."
      else
        load_form_collections
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      authorize @section
      load_form_collections
    end

    def update
      authorize @section
      if @section.update(section_params)
        redirect_to admin_sections_path, notice: "Updated."
      else
        load_form_collections
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      authorize @section
      @section.destroy!
      redirect_to admin_sections_path, notice: "Deleted."
    end

    private

    def set_section
      @section = policy_scope(Section).find(params[:id])
    end

    def section_params
      params.require(:section).permit(:school_class_id, :academic_year_id, :name, :class_teacher_id)
    end

    def load_form_collections
      @school_classes = policy_scope(SchoolClass).ordered
      @academic_years = policy_scope(AcademicYear).order(starts_on: :desc)
      @teachers = policy_scope(User).where(role: :teacher)
    end
  end
end
