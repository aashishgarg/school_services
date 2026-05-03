# frozen_string_literal: true

module Auditable
  extend ActiveSupport::Concern

  included do
    before_destroy :capture_audit_destroy_payload
    after_commit :audit_create, on: :create
    after_commit :audit_update, on: :update
    after_commit :audit_destroy, on: :destroy
  end

  private

  def capture_audit_destroy_payload
    @audit_destroy_payload = attributes.except("password_digest")
  end

  def audit_create
    write_audit("create", saved_changes)
  end

  def audit_update
    write_audit("update", saved_changes)
  end

  def audit_destroy
    write_audit("destroy", @audit_destroy_payload || {})
  end

  def write_audit(action, payload)
    return unless Current.user && respond_to?(:school_id)

    sanitized = payload.stringify_keys.except("password_digest", "password", "token")
    Audit.unscoped.create!(
      school_id: school_id,
      user_id: Current.user.id,
      action: action,
      auditable_type: self.class.name,
      auditable_id: id,
      changes_payload: sanitized
    )
  end
end
