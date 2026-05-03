# frozen_string_literal: true

class CreateBusStopProgresses < ActiveRecord::Migration[8.0]
  def change
    create_table :bus_stop_progresses do |t|
      t.references :school, null: false, foreign_key: true
      t.references :bus_trip, null: false, foreign_key: true
      t.references :bus_stop, null: false, foreign_key: true
      t.integer :status, null: false, default: 0
      t.datetime :recorded_at
      t.references :recorded_by, null: true, foreign_key: { to_table: :users }
      t.string :note

      t.timestamps
    end
    add_index :bus_stop_progresses, [ :bus_trip_id, :bus_stop_id ], unique: true, name: "index_bus_stop_progresses_on_trip_stop"
  end
end
