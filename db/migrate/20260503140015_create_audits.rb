# frozen_string_literal: true

class CreateAudits < ActiveRecord::Migration[8.0]
  def change
    create_table :audits do |t|
      t.references :school, null: false, foreign_key: true
      t.references :user, null: true, foreign_key: true
      t.string :action, null: false
      t.string :auditable_type, null: false
      t.bigint :auditable_id, null: false
      t.jsonb :changes_payload, null: false, default: {}

      t.timestamps
    end
    add_index :audits, [ :auditable_type, :auditable_id ]
    add_index :audits, :created_at
  end
end
