# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Authentication
  include Pundit::Authorization

  helper_method :current_user

  allow_browser versions: :modern unless Rails.env.test?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def pundit_user
    Current.user
  end

  private

  def user_not_authorized
    render "errors/forbidden", status: :forbidden, layout: "application"
  end

  def current_user
    Current.user
  end
end
