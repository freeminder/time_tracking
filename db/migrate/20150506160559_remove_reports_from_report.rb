class RemoveReportsFromReport < ActiveRecord::Migration
  def change
    remove_column :categories, :categories
    remove_column :reports, :categories
    remove_column :reports, :reports
  end
end
