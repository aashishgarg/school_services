# frozen_string_literal: true

class CreateBusStops < ActiveRecord::Migration[8.0]
  def change
    create_table :bus_stops do |t|
      t.references :school, null: false, foreign_key: true
      t.references :bus, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :position, null: false, default: 0
      t.time :expected_time

      t.timestamps
    end
    add_index :bus_stops, [ :bus_id, :position ], unique: true
  end
end
