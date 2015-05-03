class CreateJoinTableCategoryReport < ActiveRecord::Migration
  def change
    create_join_table :categories, :reports do |t|
      t.index [:category_id, :report_id]
      t.index [:report_id, :category_id]
    end
  end
end
