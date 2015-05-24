class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :team
  # has_one :report, dependent: :destroy
  has_many :reports, dependent: :delete_all
  # has_many :categories, dependent: :delete_all


  def self.create_new_timesheets
    User.all.each do |user|
      current_week = Date.today.strftime("%U").to_i
      @report = Report.create(user_id: user.id, week_id: current_week)
      Category.all.each do |category|
        Hour.create(category_id: category.id, report_id: @report.id)
      end
    end
  end

  def self.lock_timesheets
    current_week = Date.today.strftime("%U").to_i
    @reports = Report.where(timesheet_ready: false).where.not(week_id: current_week)
    @reports.each do |report|
      @hour = 0
      Hour.where(report_id: report.id) do |hour|
        @hour += hour.sunday if hour.sunday
        @hour += hour.monday if hour.monday
        @hour += hour.tuesday if hour.tuesday
        @hour += hour.wednesday if hour.wednesday
        @hour += hour.thursday if hour.thursday
        @hour += hour.friday if hour.friday
        @hour += hour.saturday if hour.saturday
      end
      Report.find(report.id).update(timesheet_ready: true) if @hour != 0
      UserMailer.delay.timesheet_ready_notify(User.find(report.user_id)) if @hour != 0
    end
  end

  def self.timesheet_not_ready_notify
    current_week = Date.today.strftime("%U").to_i
    @reports = Report.where(timesheet_ready: false).where.not(week_id: current_week)
    @users = Array.new
    @reports.each { |report| @users.push(User.find(report.user_id)) }
    @users.uniq!.each do |user|
      UserMailer.delay.timesheet_not_ready_notify(user)
    end
  end

end
