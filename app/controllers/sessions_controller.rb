class SessionsController < ApplicationController
  # GET /login
  def new
  end

  # POST '/sessions/create'
  def create
    user = User.find_by_username(session_params[:username])
    respond_to do |format|
      if user && user.authenticate(session_params[:password])
        session[:user_id] = user.id
        format.html { redirect_to root_url, notice: "Successfully logged in as ##{user.id} #{user.username}" }
        format.json { render :show, status: :ok, location: user }
      else
        format.html { render 'new', notice: 'Invalid Credentials.' }
        format.json { head :unprocessable_entity }
      end
    end
  end

  # GET /logout
  def destroy
    session[:user_id] = nil

    respond_to do |format|
      format.html { redirect_to root_url, notice: 'Successfully signed off.' }
      format.json { head :no_content }
    end

  end

  private

  def session_params
    params.permit(:username, :password)
  end
end
