# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper_method :current_user
  def current_user
    return if session[:user_id].nil?

    begin
      @current_user ||= User.find(session[:user_id])
    rescue ActiveRecord::RecordNotFound
      session[:user_id] = nil
      @current_user = nil
      redirect_to home_index_path
    end
  end

  helper_method :redirect_to_index_if_not_logged_in
  def redirect_to_index_if_not_logged_in
    return if !current_user.nil?

    respond_to do |format|
      format.html { redirect_to home_index_path, notice: 'Not Logged In' }
      format.json { header :forbidden }
    end
  end

  helper_method :redirect_to_dashboard_if_not_admin
  def redirect_to_dashboard_if_not_admin
    return if current_user.admin?

    respond_to do |format|
      format.html { redirect_to home_dashboard_path, notice: 'Permission denied.' }
      format.json { header :forbidden }
    end
  end

  # Global Before Actions
  before_action :redirect_to_index_if_not_logged_in
end
