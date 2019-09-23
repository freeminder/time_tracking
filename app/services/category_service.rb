class CategoryService
  def self.add_to_reports(category_id)
    Report.all.each { |report| report.hours.create(category_id: category_id, created_at: report.created_at) }
  end
end
