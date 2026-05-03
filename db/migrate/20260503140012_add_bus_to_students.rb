# frozen_string_literal: true

class AddBusToStudents < ActiveRecord::Migration[8.0]
  def change
    add_reference :students, :bus, foreign_key: true, null: true
    add_reference :students, :bus_stop, foreign_key: true, null: true
  end
end
