# frozen_string_literal: true

# Create Hours migration
class CreateHours < ActiveRecord::Migration
  def change
    create_table :hours do |t|
      t.integer :sunday
      t.integer :monday
      t.integer :tuesday
      t.integer :wednesday
      t.integer :thursday
      t.integer :friday
      t.integer :saturday

      t.datetime :created_at
    end
    add_reference :hours, :report, index: true
    add_reference :hours, :category, index: true
  end
end
