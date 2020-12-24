class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  def authenticate_user
    redirect_to new_session_path, flash: {danger: t('alert.sessions.login is needed')} unless logged_in?
  end
  
  def ensure_correct_user
    redirect_to tasks_path, flash: {danger: t('alert.users.Another user')} if current_user.id != params[:id].to_i
  end
end
