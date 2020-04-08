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

      expect(session[:user_id]).to eq @user.id
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
