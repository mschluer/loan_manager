# frozen_string_literal: true

module Api
  class RegistrationController < Api::ApiBaseController
    # It is allowed, that requests are submitted without user_id and session_key
    skip_before_action :validate_session_params
    # This endpoint is accessible even if logged out
    skip_before_action :authenticate_request

    # POST /api/register
    def register
      @user = User.new(user_params)

      if @user.save
        render json: {}, status: :ok
      else
        render json: {}, status: :unprocessable_entity
      end
    end

    def user_params
      params.require(:payload).permit(:email, :username, :password, :password_confirmation)
    end
  end
end
