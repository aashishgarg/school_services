# frozen_string_literal: true

class CreateSections < ActiveRecord::Migration[8.0]
  def change
    create_table :sections do |t|
      t.references :school, null: false, foreign_key: true
      t.references :school_class, null: false, foreign_key: true
      t.references :academic_year, null: false, foreign_key: true
      t.string :name, null: false
      t.references :class_teacher, null: true, foreign_key: { to_table: :users }

      t.timestamps
    end
    add_index :sections, [ :school_class_id, :academic_year_id, :name ], unique: true, name: "index_sections_on_class_year_name"
  end
end
