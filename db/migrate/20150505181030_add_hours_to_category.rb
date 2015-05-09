class AddHoursToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :categories, :string
    add_column :categories, :hours_for_monday, :integer
    add_column :categories, :hours_for_tuesday, :integer
    add_column :categories, :hours_for_wednesday, :integer
    add_column :categories, :hours_for_thursday, :integer
    add_column :categories, :hours_for_friday, :integer
    add_column :categories, :hours_for_saturday, :integer
    add_column :categories, :hours_for_sunday, :integer
    remove_column :reports, :hours_for_monday
    remove_column :reports, :hours_for_tuesday
    remove_column :reports, :hours_for_wednesday
    remove_column :reports, :hours_for_thursday
    remove_column :reports, :hours_for_friday
    remove_column :reports, :hours_for_saturday
    remove_column :reports, :hours_for_sunday
  end
end
