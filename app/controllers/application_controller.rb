class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  def authenticate_user
    redirect_to new_session_path, flash: {danger: t('alert.sessions.login is needed')} unless logged_in?
  end

  def correct_user_with_task
    if current_user.admin == false && current_user.id != Task.find(params[:id].to_i).user_id
      redirect_to tasks_path, flash: {danger: t('alert.users.Another user')}
    end
  end
end
