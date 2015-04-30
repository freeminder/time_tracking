class AddKeysToUsers < ActiveRecord::Migration
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :job_title, :string
    add_column :users, :team_id, :string
    add_column :users, :category_id, :string
    add_column :users, :report_id, :string
  end
end
