require 'rails_helper'

RSpec.describe "Homes", type: :request do
  before(:each) do
    @user = User.find(3)
    @user.password = '.test.'
  end

  describe "GET /index" do
    it "renders the index if the user is not logged in" do
      get "/home/index"
      expect(response).to have_http_status(:success)
    end

    it 'redirects to the users dashboard if the user is logged in' do
      post '/sessions/create', params: { username: @user.username, password: @user.password }
      get "/home/index"

      expect(response).to redirect_to(home_dashboard_url)
    end
  end

  describe "GET /dashboard" do
    it "renders the dashboard if the user is logged in" do
      post '/sessions/create', params: { username: @user.username, password: @user.password }
      get "/home/dashboard"

      expect(response).to have_http_status(:success)
    end

    it "redirects to the index if the user is not logged in" do
      get '/home/dashboard'

      expect(response).to redirect_to(home_index_url)
    end
  end
end
