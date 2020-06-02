# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/people', type: :request do
  context 'Logged in' do
    before(:each) do
      post '/sessions/create', params: { username: 'Basic', password: '.test.' }
    end

    let(:valid_attributes) do
      {
        first_name: 'FirstName',
        last_name: 'LastName',
        phone_number: '+49 170 1234 1234',
        user_id: 3
      }
    end

    let(:invalid_attributes) do
      {
        first_name: '',
        last_name: '',
        phone_number: '',
        user_id: nil
      }
    end

    describe 'GET /index' do
      it 'renders a successful response' do
        Person.create! valid_attributes
        get people_url
        expect(response).to be_successful
      end
    end

    describe 'GET /show' do
      it 'renders a successful response' do
        person = Person.create! valid_attributes
        get person_url(person)
        expect(response).to be_successful
      end

      it 'redirects if person does not exist' do
        get person_url(-1)
        expect(response).to be_redirect
      end
    end

    describe 'GET /new' do
      it 'renders a successful response' do
        get new_person_url
        expect(response).to be_successful
      end
    end

    describe 'GET /edit' do
      it 'render a successful response' do
        person = Person.create! valid_attributes
        get edit_person_url(person)
        expect(response).to be_successful
      end

      it 'redirects if person does not exist' do
        get edit_person_url(-1)
        expect(response).to be_redirect
      end
    end

    describe 'POST /create' do
      context 'with valid parameters' do
        it 'creates a new Person' do
          expect { post people_url, params: { person: valid_attributes } }.to change(Person, :count).by(1)
        end

        it 'redirects to the created person' do
          post people_url, params: { person: valid_attributes }
          expect(response).to redirect_to(person_url(Person.last))
        end
      end

      context 'with invalid parameters' do
        it 'does not create a new Person' do
          expect { post people_url, params: { person: invalid_attributes } }.to change(Person, :count).by(0)
        end

        it 'renders a successful response (i.e. to display the \'new\' template)' do
          post people_url, params: { person: invalid_attributes }
          expect(response).to be_successful
        end
      end
    end

    describe 'PATCH /update' do
      context 'with valid parameters' do
        let(:new_attributes) do
          {
            first_name: 'NewFirstName',
            last_name: 'NewLastName',
            phone_number: '+49 175 4321 4321',
            user_id: 3
          }
        end

        it 'updates the requested person' do
          person = Person.create! valid_attributes
          patch person_url(person), params: { person: new_attributes }
          person.reload

          expect(person.first_name).to eq 'NewFirstName'
          expect(person.last_name).to eq 'NewLastName'
          expect(person.phone_number).to eq '+49 175 4321 4321'
        end

        it 'redirects back to the list if person does not exist' do
          person = Person.create! valid_attributes

          patch person_url(-1), params: { person: new_attributes }
          person.reload

          expect(response).to be_redirect
          expect(person.first_name).not_to eq 'NewFirstName'
          expect(person.last_name).not_to eq 'NewLastName'
        end

        it 'redirects to the person' do
          person = Person.create! valid_attributes
          patch person_url(person), params: { person: new_attributes }
          person.reload
          expect(response).to redirect_to(person_url(person))
        end
      end

      context 'with invalid parameters' do
        it 'renders a successful response (i.e. to display the \'edit\' template)' do
          person = Person.create! valid_attributes
          patch person_url(person), params: { person: invalid_attributes }
          expect(response).to be_successful
        end
      end
    end

    describe 'DELETE /destroy' do
      it 'destroys the requested person' do
        person = Person.create! valid_attributes
        expect { delete person_url(person) }.to change(Person, :count).by(-1)
      end

      it 'redirects to the people list' do
        person = Person.create! valid_attributes
        delete person_url(person)
        expect(response).to redirect_to(people_url)
      end

      it 'redirects to the people list for non existing people' do
        delete person_url(-1)
        expect(response).to be_redirect
      end
    end
  end

  context 'Logged out' do
    describe 'GET index' do
      it 'redirects back to home#index' do
        get people_url
        expect(response).to redirect_to(home_index_url)
      end
    end

    describe 'GET show' do
      it 'redirects back to home#index for existing person-ids' do
        person = create :person
        get person_url(person)

        expect(response).to be_redirect
      end

      it 'redirects back to home#index for non-existing person-ids' do
        get person_url(-1)

        expect(response).to be_redirect
      end
    end

    describe 'GET new' do
      it 'redirects back to home#index' do
        get new_person_url

        expect(response).to redirect_to(home_index_url)
      end
    end

    describe 'GET edit' do
      it 'redirects back to home-index for existing person-ids' do
        person = create :person

        get edit_person_url(person)
        expect(response).to be_redirect
      end

      it 'redirects back to home-index for non-existing person-ids' do
        get edit_person_url(-1)
        expect(response).to be_redirect
      end
    end
  end

  context 'Other User' do
    before(:all) do
      # Log in as Basic and Create a Person for someone else
      post '/sessions/create', params: { username: 'Basic', password: '.test.' }
      @person = create :person
    end

    describe 'GET show' do
      it 'redirects to person#index if user tries to access other users people' do
        get person_url(@person)

        expect(response).to be_redirect
      end
    end

    describe 'DELETE destroy' do
      it 'redirects back to person#index if user tries to delete other users person' do
        expect do
          delete person_url(@person)
          expect(response).to be_redirect
        end.not_to change(Person, :count)
      end
    end
  end
end
