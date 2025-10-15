class DashboardController < ApplicationController
  before_action :authenticate_user!

  def show
    @stats = {
      # Task Statistics
      total_tasks: current_user.tasks.count,
      completed_tasks: current_user.tasks.completed.count,
      pending_tasks: current_user.tasks.pending.count,
      overdue_tasks: current_user.tasks.overdue.count,
      due_today: current_user.tasks.due_today.count,
      due_this_week: current_user.tasks.where(due_date: Date.current.beginning_of_week..Date.current.end_of_week).count,
      
      # Category Statistics
      total_categories: current_user.categories.count,
      tasks_by_category: current_user.categories.joins(:tasks)
                          .group('categories.name')
                          .count,
      
      # Priority Statistics
      tasks_by_priority: current_user.tasks.group(:priority).count,
      
      # Completion Rate
      completion_rate: calculate_completion_rate(current_user),
      
      # Recent Activity
      recent_completed: current_user.tasks.completed
                         .order(updated_at: :desc)
                         .limit(5),
      recent_created: current_user.tasks
                       .order(created_at: :desc)
                       .limit(5)
    }
  end

  private

  def calculate_completion_rate(user)
    total = user.tasks.count
    return 0 if total.zero?
    
    completed = user.tasks.completed.count
    (completed.to_f / total * 100).round(1)
  end
end