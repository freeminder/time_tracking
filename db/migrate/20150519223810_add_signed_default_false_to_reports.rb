class AddSignedDefaultFalseToReports < ActiveRecord::Migration
  def change
    change_column :reports, :signed, :boolean, :default => false
  end
end
