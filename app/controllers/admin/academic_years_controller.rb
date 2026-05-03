# frozen_string_literal: true

module Admin
  class AcademicYearsController < BaseController
    before_action :set_year, only: %i[ show edit update destroy ]

    def index
      @academic_years = policy_scope(AcademicYear).order(starts_on: :desc)
      authorize AcademicYear
    end

    def show
      authorize @year
    end

    def new
      @year = AcademicYear.new(school: Current.school)
      authorize @year
    end

    def create
      @year = AcademicYear.new(year_params.merge(school: Current.school))
      authorize @year
      if @year.save
        redirect_to admin_academic_years_path, notice: "Academic year created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      authorize @year
    end

    def update
      authorize @year
      if @year.update(year_params)
        redirect_to admin_academic_years_path, notice: "Academic year updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      authorize @year
      @year.destroy!
      redirect_to admin_academic_years_path, notice: "Deleted."
    end

    private

    def set_year
      @year = policy_scope(AcademicYear).find(params[:id])
    end

    def year_params
      params.require(:academic_year).permit(:name, :starts_on, :ends_on, :current)
    end
  end
end
