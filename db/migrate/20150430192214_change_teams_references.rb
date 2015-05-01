class ChangeTeamsReferences < ActiveRecord::Migration
  def change
    remove_reference :users, :name, index: true
    add_reference :users, :team, index: true
  end
end
