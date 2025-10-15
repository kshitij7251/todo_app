class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: %i[show edit update destroy toggle]

  # GET /tasks
  def index
    @tasks = current_user.tasks
    
    # Apply search if present
    @tasks = @tasks.search(params[:search]) if params[:search].present?
    
    # Apply filters if present
    @tasks = @tasks.where(completed: params[:completed]) if params[:completed].present?
    @tasks = @tasks.where(priority: params[:priority]) if params[:priority].present?
    @tasks = @tasks.where(category_id: params[:category_id]) if params[:category_id].present?
    @tasks = @tasks.overdue if params[:filter] == 'overdue'
    @tasks = @tasks.due_today if params[:filter] == 'due_today'
    
    # Quick filters
    case params[:quick_filter]
    when 'my_focus'
      @tasks = @tasks.where(priority: ['medium', 'high']).where('due_date <= ? OR due_date IS NULL', 3.days.from_now)
    when 'this_week'
      @tasks = @tasks.where(due_date: Date.current.beginning_of_week..Date.current.end_of_week)
    when 'no_category'
      @tasks = @tasks.where(category_id: nil)
    when 'with_subtasks'
      @tasks = @tasks.joins(:subtasks).distinct
    end
    
    # Default ordering
    @tasks = @tasks.order(:completed, :priority, :due_date)
    
    # Pagination
    @pagy, @tasks = pagy(@tasks, items: params[:items] || 15)
    
    # Statistics for dashboard (always based on all user tasks, not filtered)
    @stats = {
      total: current_user.tasks.count,
      completed: current_user.tasks.completed.count,
      pending: current_user.tasks.pending.count,
      overdue: current_user.tasks.overdue.count,
      due_today: current_user.tasks.due_today.count
    }
  end

  # GET /tasks/1
  def show; end

  # GET /tasks/new
  def new
    @task = current_user.tasks.build
  end

  # GET /tasks/1/edit
  def edit; end

  # POST /tasks
  def create
    @task = current_user.tasks.build(task_params)
    @task.completed = false if @task.completed.nil?

    respond_to do |format|
      if @task.save
        format.html { redirect_to tasks_path, notice: "Task was successfully created." }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to tasks_path, notice: "Task was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  def destroy
    @task.destroy!
    respond_to do |format|
      format.html { redirect_to tasks_path, notice: "Task was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  # PATCH /tasks/1/toggle
  def toggle
    if @task.update(completed: !@task.completed)
      redirect_to tasks_path, notice: "Task updated!", status: :see_other
    else
      # Handle validation errors (e.g., pending subtasks)
      error_message = @task.errors.full_messages.join('. ')
      redirect_to tasks_path, alert: error_message, status: :see_other
    end
  end

  private

  def set_task
    @task = current_user.tasks.find(params[:id])
  end

  # Strong parameters
  def task_params
    params.require(:task).permit(:title, :description, :priority, :due_date, :completed, :category_id, attachments: [])
  end
end
