class Admin::UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user
  before_action :require_admin
  
  def index
    @users = User.all.includes(:tasks)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to admin_users_path, flash: {success: t('notice.admin.user.create', user: @user.name)}
    else
      flash.now[:danger] = t('alert.users.create')
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to admin_user_path(@user), flash: {success: t('notice.admin.user.update', user: @user.name)}
    else
      flash.now[:danger] = t('alert.users.update')
      render :edit
    end
  end

  def destroy
    if @user.destroy
      redirect_to admin_users_path, flash: {success: t('notice.admin.user.destroy', user: @user.name)}
    else
      redirect_to admin_users_path, flash: {danger: t('alert.users.destroy', user: @user.name)}
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def require_admin
    redirect_to tasks_path, flash: {danger: t('alert.users.Another user')} unless current_user.admin?
  end
end
