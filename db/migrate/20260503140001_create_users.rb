# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.references :school, null: false, foreign_key: true
      t.string :email_address, null: false
      t.string :password_digest, null: false
      t.string :full_name, null: false
      t.integer :role, null: false, default: 0
      t.boolean :active, null: false, default: true

      t.timestamps
    end
    add_index :users, [ :school_id, :email_address ], unique: true
  end
end
