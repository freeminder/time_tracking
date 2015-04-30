class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :category
    end
  end
end
