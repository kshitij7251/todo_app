class TaskPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      elsif user.manager?
        scope.where(user: user).or(scope.where(assignee: user))
      else
        scope.where(assignee: user)
      end
    end
  end

  def index?
    true
  end

  def show?
    admin? || manager? || owner? || assignee?
  end

  def create?
    admin? || manager?
  end

  def update?
    admin? || owner? || (assignee? && executive_update_allowed?)
  end

  def destroy?
    admin? || owner?
  end

  def assign?
    admin? || manager?
  end

  private

  def owner?
    user == record.user
  end

  def assignee?
    user == record.assignee
  end

  def admin?
    user.admin?
  end

  def manager?
    user.manager?
  end

  def executive_update_allowed?
    # Executives can only update status and add comments
    record.changes.keys.all? { |key| ['status', 'comments'].include?(key) }
  end
end