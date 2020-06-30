# frozen_string_literal: true

module Api
  class PeopleController < Api::ApiBaseController
    before_action :set_person, only: %i[show update destroy]
    before_action :check_access_privilege, only: %i[show update destroy]

    # POST /api/people
    def index
      render json: Person.where(user_id: current_user.id), status: :ok
    end

    # POST /api/people
    def create
      @person = Person.new(person_params)
      @person.user_id = params[:user_id]

      if @person.save
        render json: @person, status: :created
      else
        respond_with_bad_request
      end
    end

    # POST /api/people/1
    def show
      render json: { person: @person, loans: @person.loans }, status: :ok
    end

    # PATCH/PUT /api/people/1
    def update
      if @person.update(person_params)
        render json: @person, status: :ok
      else
        respond_with_bad_request
      end
    end

    # DESTROY /api/people/1
    def destroy
      @person.destroy
      render json: {}, status: :no_content
    end

    private

    def set_person
      @person = Person.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      respond_with_forbidden
    end

    def person_params
      params.require(:payload).permit(:first_name, :last_name, :phone_number)
    end

    def check_access_privilege
      return if @person.user == current_user

      respond_with_forbidden
    end
  end
end
