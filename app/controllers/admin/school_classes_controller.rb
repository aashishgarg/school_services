# frozen_string_literal: true

module Admin
  class SchoolClassesController < BaseController
    before_action :set_school_class, only: %i[ show edit update destroy ]

    def index
      authorize SchoolClass
      @school_classes = policy_scope(SchoolClass).ordered
    end

    def show
      authorize @school_class
    end

    def new
      @school_class = SchoolClass.new(school: Current.school)
      authorize @school_class
    end

    def create
      @school_class = SchoolClass.new(school_class_params.merge(school: Current.school))
      authorize @school_class
      if @school_class.save
        redirect_to admin_school_classes_path, notice: "Class created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      authorize @school_class
    end

    def update
      authorize @school_class
      if @school_class.update(school_class_params)
        redirect_to admin_school_classes_path, notice: "Updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      authorize @school_class
      @school_class.destroy!
      redirect_to admin_school_classes_path, notice: "Deleted."
    end

    private

    def set_school_class
      @school_class = policy_scope(SchoolClass).find(params[:id])
    end

    def school_class_params
      params.require(:school_class).permit(:name, :position)
    end
  end
end
