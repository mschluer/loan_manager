class ApplicationController < ActionController::Base
  helper_method :current_user
  def current_user
    if session[:user_id]
      begin
        @current_user ||= User.find(session[:user_id])
      rescue ActiveRecord::RecordNotFound
        session[:user_id] = nil
        @current_user = nil
        redirect_to home_index_path
      end
    else
      @current_user = nil
    end
  end

  helper_method :redirect_to_index_if_not_logged_in
  def redirect_to_index_if_not_logged_in
    if !current_user
      respond_to do |format|
        format.html { redirect_to home_index_path, notice: 'Not Logged In' }
        format.json { header :forbidden }
      end
    end
  end

  helper_method :redirect_to_dashboard_if_not_admin
  def redirect_to_dashboard_if_not_admin
    if !current_user.admin?
      respond_to do |format|
        format.html { redirect_to home_dashboard_path, notice: 'Permission denied.' }
        format.json { header :forbidden }
      end
    end
  end

  # Global Before Actions
  before_action :redirect_to_index_if_not_logged_in
end
