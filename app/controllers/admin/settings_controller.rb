# frozen_string_literal: true

module Admin
  class SettingsController < BaseController
    def show
      @school = Current.school
      authorize @school, policy_class: SchoolPolicy
    end

    def update
      @school = Current.school
      authorize @school, policy_class: SchoolPolicy
      settings = @school.settings.dup
      settings["any_teacher_can_mark_bus"] = params[:any_teacher_can_mark_bus] == "1"
      settings["attendance_halves_enabled"] = params[:attendance_halves_enabled] == "1"
      if @school.update(settings: settings)
        redirect_to admin_settings_path, notice: "Settings updated."
      else
        render :show, status: :unprocessable_entity
      end
    end
  end
end
