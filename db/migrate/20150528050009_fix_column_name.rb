class FixColumnName < ActiveRecord::Migration
  def change
    rename_column :reports, :timesheet_ready, :timesheet_locked
  end
end
