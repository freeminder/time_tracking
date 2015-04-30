class RemoveFieldsFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :category_id
    remove_column :users, :report_id
  end
end
