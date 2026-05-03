# frozen_string_literal: true

module Admin
  class BaseController < ApplicationController
    before_action :require_admin

    private

    def require_admin
      raise Pundit::NotAuthorizedError, "Admins only" unless Current.user&.admin?
    end
  end
end
