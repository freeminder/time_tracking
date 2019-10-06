# frozen_string_literal: true

# Create Teams migration
class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name
    end
    add_reference :users, :team, index: true
  end
end
