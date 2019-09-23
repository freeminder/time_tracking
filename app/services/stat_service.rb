class StatService
  def self.get_user_hours(user, opts = {})
    user_reports = opts[:preloaded_data][:reports].select { |report| report.user_id == user.id }
    categories = {}
    opts[:preloaded_data][:categories_all] = [opts[:preloaded_data][:single_category]] if opts[:preloaded_data][:single_category]
    opts[:preloaded_data][:categories_all].each do |category|
      hours = opts[:preloaded_data][:hours].select do |hour|
        hour.category_id == category.id && user_reports.map { |report| report.id }.include?(hour.report_id)
      end
      # precise hours calculation by days from the first week
      hffw = hours.select { |hour| hour.created_at.strftime("%U").to_i == opts[:preloaded_data][:date].strftime("%U").to_i }
      fwhc = hffw.map { |hour| hour.week_attrs.to_a[opts[:preloaded_data][:date].wday,6].to_h.values.compact.sum }.sum
      owhc = (hours - hffw).map { |hour| hour.week_attrs.values.compact.sum }.sum
      categories.merge!(category.name => fwhc + owhc) # first week hours count + other weeks hours count
    end
    { user_full_name: user.full_name, user_rate: user.rate, categories: categories }
  end
end
