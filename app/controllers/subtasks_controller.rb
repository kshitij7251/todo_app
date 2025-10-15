class SubtasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task
  before_action :set_subtask, only: [:destroy, :toggle]

  def create
    @subtask = @task.subtasks.build(subtask_params)
    @subtask.user = current_user
    @subtask.completed = false

    if @subtask.save
      redirect_to @task, notice: 'Subtask was successfully created.'
    else
      redirect_to @task, alert: 'Unable to create subtask.'
    end
  end

  def destroy
    @subtask.destroy
    redirect_to @task, notice: 'Subtask was successfully deleted.'
  end

  def toggle
    @subtask.toggle_completion!
    redirect_to @task, notice: 'Subtask updated.'
  end

  private

  def set_task
    @task = current_user.tasks.find(params[:task_id])
  end

  def set_subtask
    @subtask = @task.subtasks.find(params[:id])
  end

  def subtask_params
    params.require(:subtask).permit(:title, :description)
  end
end
