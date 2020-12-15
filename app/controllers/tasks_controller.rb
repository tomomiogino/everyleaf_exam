class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  def index
    @tasks = Task.all
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to task_path(@task.id), notice: "#{@task.title}を新規登録しました！"
    else
      flash.now[:alert] = '登録に失敗しました'
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to tasks_path, notice: "タスク『#{@task.title}』を更新しました！"
    else
      flash.now[:alert] = '更新に失敗しました'
      render :edit
    end
  end
  
  def destroy
    @task.destroy
    redirect_to tasks_path, notice: "タスク『#{@task.title}』を削除しました！"
  end

  private
  def task_params
    params.require(:task).permit(:title, :content)
  end

  def set_task
    @task = Task.find(params[:id])
  end
end
