class HomeController < ApplicationController
  skip_before_action :redirect_to_index_if_not_logged_in, only: :index
  def index
    if current_user
      respond_to do |format|
        format.html { redirect_to home_dashboard_path }
        format.json { head :no_content }
      end
    end
  end

  def dashboard
    
  end
end
