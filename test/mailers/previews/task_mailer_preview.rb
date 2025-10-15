# Preview all emails at http://localhost:3000/rails/mailers/task_mailer
class TaskMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/task_mailer/daily_digest
  def daily_digest
    TaskMailer.daily_digest
  end

  # Preview this email at http://localhost:3000/rails/mailers/task_mailer/overdue_tasks
  def overdue_tasks
    TaskMailer.overdue_tasks
  end

  # Preview this email at http://localhost:3000/rails/mailers/task_mailer/due_today_tasks
  def due_today_tasks
    TaskMailer.due_today_tasks
  end

  # Preview this email at http://localhost:3000/rails/mailers/task_mailer/weekly_summary
  def weekly_summary
    TaskMailer.weekly_summary
  end
end
