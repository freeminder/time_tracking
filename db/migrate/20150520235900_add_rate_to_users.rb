class AddRateToUsers < ActiveRecord::Migration
  def change
    add_column :users, :rate, :integer, :default => 0
  end
end
