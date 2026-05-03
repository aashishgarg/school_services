# frozen_string_literal: true

class CreateSchools < ActiveRecord::Migration[8.0]
  def change
    create_table :schools do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.string :time_zone, null: false, default: "UTC"
      t.jsonb :settings, null: false, default: {}

      t.timestamps
    end
    add_index :schools, :slug, unique: true
  end
end
