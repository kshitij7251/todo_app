class Task < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :category, optional: true
  has_many :subtasks, foreign_key: 'parent_task_id', dependent: :destroy
  has_many_attached :attachments
  
  enum :priority, { low: 0, medium: 1, high: 2 }
  
  validates :title, presence: true, length: { minimum: 1, maximum: 255 }
  validates :completed, inclusion: { in: [true, false] }
  validate :cannot_complete_with_pending_subtasks, if: :completed_changed_to_true?
  
  scope :completed, -> { where(completed: true) }
  scope :pending, -> { where(completed: false) }
  scope :overdue, -> { where('due_date < ? AND completed = ?', Time.current, false) }
  scope :due_today, -> { where(due_date: Date.current.beginning_of_day..Date.current.end_of_day) }
  scope :by_priority, -> { order(:priority) }
  scope :by_due_date, -> { order(:due_date) }
  scope :search, ->(term) { 
    joins("LEFT JOIN subtasks ON subtasks.parent_task_id = tasks.id")
      .where("tasks.title ILIKE ? OR tasks.description ILIKE ? OR subtasks.title ILIKE ? OR subtasks.description ILIKE ?", 
             "%#{term}%", "%#{term}%", "%#{term}%", "%#{term}%")
      .distinct
  }
  
  def overdue?
    due_date.present? && due_date < Time.current && !completed?
  end
  
  def due_today?
    due_date.present? && due_date.to_date == Date.current
  end
  
  def priority_color
    case priority
    when 'high'
      'text-red-600 bg-red-100'
    when 'medium'
      'text-yellow-600 bg-yellow-100'
    when 'low'
      'text-green-600 bg-green-100'
    else
      'text-gray-600 bg-gray-100'
    end
  end
  
  # Subtask progress methods
  def subtasks_count
    subtasks.count
  end
  
  def completed_subtasks_count
    subtasks.completed.count
  end
  
  def subtasks_completion_percentage
    return 0 if subtasks_count.zero?
    (completed_subtasks_count.to_f / subtasks_count * 100).round
  end
  
  def has_subtasks?
    subtasks_count > 0
  end
  
  def has_pending_subtasks?
    subtasks.pending.exists?
  end
  
  def pending_subtasks_count
    subtasks.pending.count
  end
  
  private
  
  def completed_changed_to_true?
    completed_changed? && completed == true
  end
  
  def cannot_complete_with_pending_subtasks
    if has_pending_subtasks?
      errors.add(:completed, "cannot be marked as complete while #{pending_subtasks_count} subtask(s) are still pending. Please complete all subtasks first.")
    end
  end
end
