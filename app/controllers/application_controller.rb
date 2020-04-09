class ApplicationController < ActionController::Base
  helper_method :current_user
  def current_user
    if session[:user_id]
      @current_user ||= User.find(session[:user_id])
    else
      @current_user = nil
    end
  end

  helper_method :lock_action
  def redirect_to_index_if_not_logged_in
    if !current_user
      respond_to do |format|
        format.html { redirect_to home_index_path, notice: 'Not Logged In' }
        format.json { header :forbidden }
      end
    end
  end
end
