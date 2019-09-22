class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable
  belongs_to :team
  has_many :reports, dependent: :delete_all
  has_many :hours, through: :reports

  validates :email, :first_name, :last_name, :rate, :team, presence: true
  validates :email, uniqueness: true, on: :create

  def full_name
    ([first_name, last_name] - ['']).compact.join(' ')
  end

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
    @reports = Report.where(timesheet_locked: false).where.not(week_id: current_week)
    @reports.each do |report|
      @hour = 0
      Hour.where(report_id: report.id).each do |hour|
        @hour += hour.sunday if hour.sunday
        @hour += hour.monday if hour.monday
        @hour += hour.tuesday if hour.tuesday
        @hour += hour.wednesday if hour.wednesday
        @hour += hour.thursday if hour.thursday
        @hour += hour.friday if hour.friday
        @hour += hour.saturday if hour.saturday
      end
      report.update(timesheet_locked: true) if @hour > 0
      UserMailer.delay.timesheet_ready_notify(User.find(report.user_id)) if @hour > 0
    end
  end

  def self.timesheet_not_ready_notify
    current_week = Date.today.strftime("%U").to_i
    @reports = Report.where(timesheet_locked: false).where.not(week_id: current_week)
    @users = Array.new
    @reports.each { |report| @users.push(User.find(report.user_id)) }
    @users.uniq!.each do |user|
      UserMailer.delay.timesheet_not_ready_notify(user)
    end
  end

end
