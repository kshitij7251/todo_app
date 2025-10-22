class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :tasks, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :subtasks, dependent: :destroy
  has_many :assigned_tasks, class_name: 'Task', foreign_key: 'assignee_id'

  enum role: { executive: 0, manager: 1, admin: 2 }
  
  after_initialize :set_default_role, if: :new_record?

  private

  def set_default_role
    self.role ||= :executive
  end
end
