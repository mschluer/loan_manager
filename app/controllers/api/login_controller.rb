# frozen_string_literal: true

module Api
  class LoginController < Api::ApiBaseController
    # In order to log in users must be able to send requests without user_id and session_key
    skip_before_action :validate_session_params, only: :login
    skip_before_action :authenticate_request, only: :login

    # POST /api/login
    def login
      user = User.find_by_username(login_params[:username])

      if !user.authenticate(login_params[:password])
        render json: {}, status: :unprocessable_entity
        return
      end

      session = Api::Session.new(user_id: user.id, expiry_date: 1.day.from_now)
      session.set_key

      if session.save
        render json: {
          user_id: user.id,
          session_key: session.key
        }, status: :ok
      else
        render json: {}, status: :unprocessable_entity
      end
    end

    # POST /api/logout
    def logout
      session = Api::Session.find_by_key(params[:session_key])

      if session.destroy
        render json: {}, status: :ok
      else
        render json: {}, status: :unprocessable_entity
      end
    end

    # POST /api/logout_all
    def logout_all
      current_user.kill_all_sessions
      render json: {}, status: :ok
    end

    private

    def login_params
      params.require(:payload).permit(:username, :password)
    end
  end
end
