# frozen_string_literal: true

class CreateAttendanceSessions < ActiveRecord::Migration[8.0]
  def change
    create_table :attendance_sessions do |t|
      t.references :school, null: false, foreign_key: true
      t.references :section, null: false, foreign_key: true
      t.date :on_date, null: false
      t.integer :half, null: false, default: 0
      t.references :taken_by, null: true, foreign_key: { to_table: :users }
      t.datetime :taken_at

      t.timestamps
    end
    add_index :attendance_sessions, [ :section_id, :on_date, :half ], unique: true, name: "index_attendance_sessions_on_section_date_half"
  end
end
