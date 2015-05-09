class CreateHours < ActiveRecord::Migration
  def change
    create_table :hours do |t|
      t.integer :sunday
      t.integer :monday
      t.integer :tuesday
      t.integer :wednesday
      t.integer :thursday
      t.integer :friday
      t.integer :saturday
    end
    add_reference :reports, :hour, index: true
  end
end
