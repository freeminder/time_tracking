class AddTimesheetReadyToReports < ActiveRecord::Migration
  def change
    add_column :reports, :timesheet_ready, :boolean, :default => false
  end
end
