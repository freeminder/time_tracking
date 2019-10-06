# frozen_string_literal: true

# Create Categories migration
class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
    end
  end
end
