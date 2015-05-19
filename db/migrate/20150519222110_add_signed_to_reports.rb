class AddSignedToReports < ActiveRecord::Migration
  def change
    add_column :reports, :signed, :boolean
  end
end
