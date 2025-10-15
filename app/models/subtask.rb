class Subtask < ApplicationRecord
  belongs_to :parent_task, class_name: 'Task'
  belongs_to :user
  
  validates :title, presence: true, length: { minimum: 1, maximum: 255 }
  validates :completed, inclusion: { in: [true, false] }
  
  scope :completed, -> { where(completed: true) }
  scope :pending, -> { where(completed: false) }
  
  def toggle_completion!
    update!(completed: !completed)
  end
end
