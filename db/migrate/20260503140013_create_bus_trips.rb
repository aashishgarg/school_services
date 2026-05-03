# frozen_string_literal: true

class CreateBusTrips < ActiveRecord::Migration[8.0]
  def change
    create_table :bus_trips do |t|
      t.references :school, null: false, foreign_key: true
      t.references :bus, null: false, foreign_key: true
      t.date :on_date, null: false
      t.integer :shift, null: false, default: 0
      t.datetime :started_at
      t.datetime :completed_at

      t.timestamps
    end
    add_index :bus_trips, [ :bus_id, :on_date, :shift ], unique: true, name: "index_bus_trips_on_bus_date_shift"
  end
end
