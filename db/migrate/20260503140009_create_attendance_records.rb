# frozen_string_literal: true

class CreateAttendanceRecords < ActiveRecord::Migration[8.0]
  def change
    create_table :attendance_records do |t|
      t.references :school, null: false, foreign_key: true
      t.references :attendance_session, null: false, foreign_key: true
      t.references :student, null: false, foreign_key: true
      t.integer :status, null: false, default: 0
      t.string :note

      t.timestamps
    end
    add_index :attendance_records, [ :attendance_session_id, :student_id ], unique: true, name: "index_attendance_records_on_session_student"
  end
end
