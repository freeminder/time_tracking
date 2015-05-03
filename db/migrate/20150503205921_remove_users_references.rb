class RemoveUsersReferences < ActiveRecord::Migration
  def change
    remove_reference :users, :report, index: true
    add_reference :reports, :user, index: true
  end
end
