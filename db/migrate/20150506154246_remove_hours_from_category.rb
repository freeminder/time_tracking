class RemoveHoursFromCategory < ActiveRecord::Migration
  def change
    remove_column :categories, :hours_for_monday, :integer
    remove_column :categories, :hours_for_tuesday, :integer
    remove_column :categories, :hours_for_wednesday, :integer
    remove_column :categories, :hours_for_thursday, :integer
    remove_column :categories, :hours_for_friday, :integer
    remove_column :categories, :hours_for_saturday, :integer
    remove_column :categories, :hours_for_sunday, :integer
    add_column :reports, :hours_for_monday, :integer
    add_column :reports, :hours_for_tuesday, :integer
    add_column :reports, :hours_for_wednesday, :integer
    add_column :reports, :hours_for_thursday, :integer
    add_column :reports, :hours_for_friday, :integer
    add_column :reports, :hours_for_saturday, :integer
    add_column :reports, :hours_for_sunday, :integer
  end
end
