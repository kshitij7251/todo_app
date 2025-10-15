class TaskMailer < ApplicationMailer
  default from: 'todo-app@example.com'

  def daily_digest(user)
    @user = user
    @pending_tasks = user.tasks.pending.limit(10)
    @overdue_count = user.tasks.overdue.count
    @due_today_count = user.tasks.due_today.count
    @completed_yesterday = user.tasks.where(
      completed: true, 
      updated_at: 1.day.ago.beginning_of_day..1.day.ago.end_of_day
    ).count

    mail(
      to: user.email,
      subject: "Daily Task Digest - #{@pending_tasks.count} pending tasks"
    )
  end

  def overdue_tasks(user)
    @user = user
    @overdue_tasks = user.tasks.overdue.includes(:category, :subtasks)

    mail(
      to: user.email,
      subject: "⚠️ You have #{@overdue_tasks.count} overdue tasks"
    )
  end

  def due_today_tasks(user)
    @user = user
    @due_today_tasks = user.tasks.due_today.includes(:category, :subtasks)

    mail(
      to: user.email,
      subject: "📅 #{@due_today_tasks.count} tasks due today"
    )
  end

  def weekly_summary(user)
    @user = user
    
    # Calculate week stats
    week_start = 1.week.ago.beginning_of_week
    week_end = 1.week.ago.end_of_week
    
    @completed_this_week = user.tasks.where(
      completed: true,
      updated_at: week_start..week_end
    ).count
    
    @total_tasks = user.tasks.count
    @pending_tasks = user.tasks.pending.count
    @upcoming_tasks = user.tasks.where(
      due_date: Date.current..1.week.from_now,
      completed: false
    ).includes(:category).limit(5)
    
    @top_categories = user.categories
      .joins(:tasks)
      .where(tasks: { completed: true, updated_at: week_start..week_end })
      .group('categories.id')
      .order('COUNT(tasks.id) DESC')
      .limit(3)

    mail(
      to: user.email,
      subject: "📊 Weekly Summary - #{@completed_this_week} tasks completed"
    )
  end
end
