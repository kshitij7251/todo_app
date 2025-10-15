class NotificationSchedulerJob < ApplicationJob
  queue_as :default

  def perform(notification_type)
    case notification_type
    when 'daily_digest'
      send_daily_digests
    when 'overdue_reminders'
      send_overdue_reminders
    when 'due_today_reminders'
      send_due_today_reminders
    when 'weekly_summary'
      send_weekly_summaries
    end
  end

  private

  def send_daily_digests
    User.find_each do |user|
      TaskMailer.daily_digest(user).deliver_now
    end
  end

  def send_overdue_reminders
    User.joins(:tasks)
        .where(tasks: { completed: false, due_date: ...Time.current })
        .distinct
        .find_each do |user|
      TaskMailer.overdue_tasks(user).deliver_now
    end
  end

  def send_due_today_reminders
    User.joins(:tasks)
        .where(tasks: { 
          completed: false, 
          due_date: Date.current.beginning_of_day..Date.current.end_of_day 
        })
        .distinct
        .find_each do |user|
      TaskMailer.due_today_tasks(user).deliver_now
    end
  end

  def send_weekly_summaries
    User.find_each do |user|
      TaskMailer.weekly_summary(user).deliver_now
    end
  end
end
