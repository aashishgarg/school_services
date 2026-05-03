# frozen_string_literal: true

class CreateStudents < ActiveRecord::Migration[8.0]
  def change
    create_table :students do |t|
      t.references :school, null: false, foreign_key: true
      t.references :section, null: false, foreign_key: true
      t.string :admission_no, null: false
      t.string :full_name, null: false
      t.string :gender
      t.date :dob
      t.string :guardian_name
      t.string :guardian_phone

      t.timestamps
    end
    add_index :students, [ :school_id, :admission_no ], unique: true
  end
end
