# frozen_string_literal: true

# Create Reports migration
class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.integer :week_id
      t.boolean :signed, default: false
      t.boolean :timesheet_locked, default: false

      t.timestamps
    end
    add_reference :reports, :user, index: true
  end
end
