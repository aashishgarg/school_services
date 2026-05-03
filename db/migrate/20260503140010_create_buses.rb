# frozen_string_literal: true

class CreateBuses < ActiveRecord::Migration[8.0]
  def change
    create_table :buses do |t|
      t.references :school, null: false, foreign_key: true
      t.string :name, null: false
      t.string :plate_no, null: false
      t.integer :capacity
      t.references :in_charge_user, null: true, foreign_key: { to_table: :users }

      t.timestamps
    end
    add_index :buses, [ :school_id, :plate_no ], unique: true
  end
end
