# frozen_string_literal: true

# Stat service
class StatService
  attr_accessor :user, :opts

  def initialize(user, opts = {})
    @user = user
    @opts = opts
  end

  def user_hours
    categories = {}

    categories_all.each do |category|
      @category = category
      categories.merge!(
        category.name => first_week_hours_count + other_weeks_hours_count
      )
    end

    {
      user_full_name: user.full_name,
      user_rate: user.rate,
      categories: categories
    }
  end

  private

  def categories_all
    if opts[:preloaded_data][:single_category]
      [opts[:preloaded_data][:single_category]]
    else
      opts[:preloaded_data][:categories_all]
    end
  end

  def user_reports
    opts[:preloaded_data][:reports].select { |r| r.user_id == user.id }
  end

  def hours
    opts[:preloaded_data][:hours].select do |h|
      h.category_id == @category.id && \
        user_reports.map(&:id).include?(h.report_id)
    end
  end

  def hours_for_first_week
    hours.select do |hour|
      hour.created_at.strftime('%U').to_i == \
        opts[:preloaded_data][:date].strftime('%U').to_i
    end
  end

  def first_week_hours_count
    hours_for_first_week.map do |hour|
      hour.week_attrs.to_a[opts[:preloaded_data][:date].wday, 6].to_h
          .values.compact.sum
    end.sum
  end

  def other_weeks_hours_count
    (hours - hours_for_first_week).map do |hour|
      hour.week_attrs.values.compact.sum
    end.sum
  end
end
