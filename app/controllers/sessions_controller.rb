class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: session_params[:email].downcase)
    if user && user.authenticate(session_params[:password])
      session[:user_id] = user.id
      redirect_to user_path(user.id), flash: {success: t('success.sessions.create')}
    else
      flash.now[:danger] = t('alert.sessions.create')
      render :new
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to new_session_path, flash: {success: t('success.sessions.destroy')}
  end

  private
  def session_params
    params.require(:session).permit(:email, :password)
  end
end
