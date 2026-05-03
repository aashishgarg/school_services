# frozen_string_literal: true

class CreateAcademicYears < ActiveRecord::Migration[8.0]
  def change
    create_table :academic_years do |t|
      t.references :school, null: false, foreign_key: true
      t.string :name, null: false
      t.date :starts_on, null: false
      t.date :ends_on, null: false
      t.boolean :current, null: false, default: false

      t.timestamps
    end
    add_index :academic_years, [ :school_id, :name ], unique: true
  end
end
