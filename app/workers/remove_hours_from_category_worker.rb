# frozen_string_literal: true

# remove hours on category destroy
class RemoveHoursFromCategoryWorker
  include Sidekiq::Worker

  def perform(category_id)
    Hour.where(category_id: category_id).destroy_all
  end
end
