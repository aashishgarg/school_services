# frozen_string_literal: true

module Admin
  class AuditsController < BaseController
    def index
      authorize Audit
      @audits = policy_scope(Audit).order(created_at: :desc).includes(:user)
      @audits = @audits.where(user_id: params[:user_id]) if params[:user_id].present?
      @audits = @audits.where(auditable_type: params[:auditable_type]) if params[:auditable_type].present?
      if params[:from].present?
        @audits = @audits.where("created_at >= ?", Time.zone.parse(params[:from]).beginning_of_day)
      end
      if params[:to].present?
        @audits = @audits.where("created_at <= ?", Time.zone.parse(params[:to]).end_of_day)
      end
      @audits = @audits.limit(200)
    end
  end
end
