# frozen_string_literal: true

class CreateTeacherAssignments < ActiveRecord::Migration[8.0]
  def change
    create_table :teacher_assignments do |t|
      t.references :school, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :section, null: false, foreign_key: true
      t.integer :role, null: false, default: 0

      t.timestamps
    end
    add_index :teacher_assignments, [ :user_id, :section_id, :role ], unique: true, name: "index_teacher_assignments_on_user_section_role"
  end
end
