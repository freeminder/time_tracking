class AddWeekIdToReports < ActiveRecord::Migration
  def change
    add_column :reports, :week_id, :integer
    remove_column :reports, :hours_for_monday
    remove_column :reports, :hours_for_tuesday
    remove_column :reports, :hours_for_wednesday
    remove_column :reports, :hours_for_thursday
    remove_column :reports, :hours_for_friday
    remove_column :reports, :hours_for_saturday
    remove_column :reports, :hours_for_sunday
  end
end
