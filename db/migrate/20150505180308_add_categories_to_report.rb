class AddCategoriesToReport < ActiveRecord::Migration
  def change
    remove_column :reports, :data
    remove_column :reports, :day
    remove_column :reports, :hours
    add_column :reports, :categories, :string
    add_column :reports, :hours_for_monday, :integer
    add_column :reports, :hours_for_tuesday, :integer
    add_column :reports, :hours_for_wednesday, :integer
    add_column :reports, :hours_for_thursday, :integer
    add_column :reports, :hours_for_friday, :integer
    add_column :reports, :hours_for_saturday, :integer
    add_column :reports, :hours_for_sunday, :integer
  end
end
