class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  def index
    @tasks = Task.all
    @search_task_params = search_task_params
    @tasks = @tasks.search(@search_task_params)
    if params[:sort_expired].present?
      @tasks = @tasks.order(deadline: :desc)
    elsif params[:sort_priority].present?
      @tasks = @tasks.order(priority: :asc)
    else
      @tasks = @tasks.order(created_at: :desc)
    end
    @tasks = @tasks.page(params[:page]).per(10)
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to task_path(@task.id), notice: t('notice.create', task: @task.title)
    else
      flash.now[:alert] = t('alert.create')
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to tasks_path, notice: t('notice.update', task: @task.title)
    else
      flash.now[:alert] = t('alert.update')
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_path, notice: t('notice.destroy', task: @task.title)
  end

  private
  def task_params
    params.require(:task).permit(:title, :content, :deadline, :status, :priority)
  end

  def set_task
    @task = Task.find(params[:id])
  end

  def search_task_params
    params.fetch(:task, {}).permit(:title, :status)
  end
end
