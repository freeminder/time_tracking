class AddDayToReport < ActiveRecord::Migration
  def change
    add_column :reports, :day, :string
  end
end
