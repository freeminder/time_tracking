class AddReferenceByCategoryToHours < ActiveRecord::Migration
  def change
    add_reference :hours, :category, index: true
  end
end
