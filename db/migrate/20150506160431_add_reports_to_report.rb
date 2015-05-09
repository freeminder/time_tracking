class AddReportsToReport < ActiveRecord::Migration
  def change
    add_column :reports, :reports, :string
  end
end
