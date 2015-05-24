class RemoveTimesheetLockedFromReports < ActiveRecord::Migration
  def change
    remove_column :reports, :timesheet_locked
  end
end
