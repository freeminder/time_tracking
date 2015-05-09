class AddReferenceToCategory < ActiveRecord::Migration
  def change
    remove_reference :categories, :reports, index: true
    add_reference :categories, :report, index: true
  end
end
