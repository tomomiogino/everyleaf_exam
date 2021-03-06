module SessionsHelper

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    current_user.present?
  end

  def restrict_login_user
    redirect_to tasks_path, flash: {danger: t('alert.users.logged in')} if logged_in?
  end

  def ensure_correct_user
    redirect_to tasks_path, flash: {danger: t('alert.users.Another user')} if current_user.id != params[:id].to_i
  end
end
