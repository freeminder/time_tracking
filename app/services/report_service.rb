class ReportService
  def self.search(current_user, params)
    date = Time.strptime(params[:date_custom],"%m/%d/%Y")
    date_beg = DateTime.parse(date.to_s).beginning_of_week(start_day = :sunday)
    date_end = DateTime.parse(date.to_s).end_of_week(start_day = :sunday)
    Report.where("user_id = ? AND created_at >= ? AND created_at <= ?", current_user.id, date_beg, date_end)
  end
end
