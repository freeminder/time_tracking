class ChangeTeamsTeamToName < ActiveRecord::Migration
  def change
    remove_column :teams, :team
    remove_reference :users, :team, index: true
    add_column :teams, :name, :string, default: true
    add_reference :users, :name, index: true
  end
end
