require 'rails_helper'

RSpec.describe "Legals", type: :request do

  describe "GET /disclaimer" do
    it "returns http success" do
      get "/legal/disclaimer"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /privacy" do
    it "returns http success" do
      get "/legal/privacy"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /legal_note" do
    it "returns http success" do
      get "/legal/legal_note"
      expect(response).to have_http_status(:success)
    end
  end

end
