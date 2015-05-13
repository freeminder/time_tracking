class AddCategoryToReport < ActiveRecord::Migration
  def change
    remove_column :categories, :reports
    remove_column :reports, :categories_id
    add_column :reports, :week_id, :integer
  end
end
