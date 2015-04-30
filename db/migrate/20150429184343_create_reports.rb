class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.string :name
    end

    drop_table :categories

    create_table :categories do |t|
      t.string :name
    end
    
    add_reference :categories, :reports, index: true
    add_reference :reports, :categories, index: true
  end
end
