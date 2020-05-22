require 'rails_helper'

RSpec.describe "Settings", type: :request do

  describe "GET /index" do
    it "returns redirect if not logged in" do
      get "/settings/index"
      expect(response).to have_http_status(:redirect)
    end

    it "returns success if logged in" do
      post "/sessions/create", params: { username: "Basic", password: ".test." }

      get "/settings/index"
      expect(response).to have_http_status(:success)
    end
  end
end
