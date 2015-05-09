class Hour < ActiveRecord::Base
  belongs_to :report
  belongs_to :category
end
