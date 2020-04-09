class HomeController < ApplicationController
  def index
    if current_user
      respond_to do |format|
        format.html { redirect_to home_dashboard_path }
        format.json { head :no_content }
      end
    end
  end

  def dashboard
    if !current_user
      respond_to do |format|
        format.html { redirect_to home_index_path, notice: 'Please log in to view your Dashboard.'}
        format.json { head :forbidden }
      end
    end
  end
end
