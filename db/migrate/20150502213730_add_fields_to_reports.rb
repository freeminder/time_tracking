class AddFieldsToReports < ActiveRecord::Migration
  def change
    add_column :reports, :data, :text
  end
end
