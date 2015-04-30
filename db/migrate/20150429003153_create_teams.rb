class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :team
    end
  end
end
