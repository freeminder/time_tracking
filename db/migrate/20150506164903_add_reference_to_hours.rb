class AddReferenceToHours < ActiveRecord::Migration
  def change
    remove_reference :reports, :hour, index: true
    add_reference :hours, :report, index: true
  end
end
