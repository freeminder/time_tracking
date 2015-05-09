class AddReportsToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :reports, :string
  end
end
