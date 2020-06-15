# frozen_string_literal: true

module Api
  class ApiBaseController < ActionController::Base
    skip_before_action :verify_authenticity_token

    helper_method :authenticate_request
    def authenticate_request
      return if session_token_valid?

      respond_with_forbidden
    end

    helper_method :respond_with_forbidden
    def respond_with_forbidden
      respond_to do |format|
        format.html { render text: 'Not Found', status: 404 }
        format.json { header :forbidden }
      end
    end

    # Global Before Actions
    before_action :authenticate_request

    private

    def session_token_valid?
      user = User.find params[:user_id]
      return false unless user

      user.validate_sessions

      session_key = params[:session_key]
      user.session_with? session_key
    end
  end
end
