require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  before(:each) do
    @user = create(:user)
  end

  describe "GET /new" do
    it "returns http success" do
      get "/sessions/new"

      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      post '/sessions/create', params: { username: @user.username, password: @user.password }

      expect(response).to redirect_to(home_dashboard_path)

      expect(session[:user_id]).to eq @user.id
    end

    it "redirects back if password is empty" do
      post '/sessions/create', params: { username: @user.username, password: '' }

      expect(response).to be_successful

      expect(session[:user_id]).to be_nil
    end

    it "redirects back if password is wrong" do
      post '/sessions/create', params: { username: @user.username, password: 'wrong password' }

      expect(response).to be_successful

      expect(session[:user_id]).to be_nil
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      post '/sessions/create', params: { username: @user.username, password: @user.password }
      expect(session[:user_id]).to eq @user.id

      get "/logout"

      expect(session[:user_id]).to be_nil
    end
  end

end
