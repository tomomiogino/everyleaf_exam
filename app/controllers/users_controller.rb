class UsersController < ApplicationController
  before_action :authenticate_user, only: [:show]
  before_action :ensure_correct_user, only: [:show]
  before_action :restrict_login_user, only: [:new, :create]
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to user_path(@user), flash: {success: t('notice.user.create', user: @user.name)}
    else
      flash.now[:danger] = t('alert.users.create')
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
  end
end
