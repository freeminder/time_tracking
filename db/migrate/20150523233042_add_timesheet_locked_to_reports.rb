class AddTimesheetLockedToReports < ActiveRecord::Migration
  def change
    add_column :reports, :timesheet_locked, :boolean, :default => false
  end
end
