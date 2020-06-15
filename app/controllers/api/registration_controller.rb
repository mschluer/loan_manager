# frozen_string_literal: true

module Api
  class RegistrationController < Api::ApiBaseController
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
