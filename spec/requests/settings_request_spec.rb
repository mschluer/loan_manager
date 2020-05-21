require 'rails_helper'

RSpec.describe "Settings", type: :request do

  describe "GET /index" do
    it "returns http success" do
      get "/settings/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /change_password" do
    it "returns http success" do
      get "/settings/change_password"
      expect(response).to have_http_status(:success)
    end
  end

end
