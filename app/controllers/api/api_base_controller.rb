# frozen_string_literal: true

module Api
  class ApiBaseController < ActionController::Base
    # Global Before Actions
    before_action :validate_session_params
    before_action :authenticate_request
    skip_before_action :verify_authenticity_token

    helper_method :validate_session_params
    def validate_session_params
      return if params.key?(:user_id) && params.key?(:session_key)

      respond_with_forbidden
    end

    helper_method :authenticate_request
    def authenticate_request
      return if session_token_valid?

      respond_with_forbidden
    end

    helper_method :respond_with_forbidden
    def respond_with_forbidden
      render json: {}, status: :forbidden
    end

    helper_method :respond_with_bad_request
    def respond_with_bad_request
      render json: {}, status: :bad_request
    end

    helper_method :current_user
    def current_user
      User.find params[:user_id]
    rescue ActiveRecord::RecordNotFound
      respond_with_forbidden
    end

    private

    def session_token_valid?
      return false unless (user = current_user)

      user.validate_sessions
      user.session_with? params[:session_key]
    end
  end
end
