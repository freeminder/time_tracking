class AddWdaysToReports < ActiveRecord::Migration
  def change
    add_column :reports, :wday, :text
  end
end
