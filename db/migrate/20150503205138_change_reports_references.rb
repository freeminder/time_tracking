class ChangeReportsReferences < ActiveRecord::Migration
  def change
    add_reference :users, :report, index: true
  end
end
