class AddHoursToReport < ActiveRecord::Migration
  def change
    add_column :reports, :hours, :integer
    remove_column :reports, :data
    remove_column :reports, :wday
    add_column(:reports, :created_at, :datetime)
    add_column(:reports, :updated_at, :datetime)
  end
end
