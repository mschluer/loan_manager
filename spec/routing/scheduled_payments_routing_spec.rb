# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ScheduledPaymentsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/scheduled_payments').to route_to('scheduled_payments#index')
    end

    it 'routes to #new' do
      expect(get: '/scheduled_payments/new').to route_to('scheduled_payments#new')
    end

    it 'routes to #show' do
      expect(get: '/scheduled_payments/1').to route_to('scheduled_payments#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/scheduled_payments/1/edit').to route_to('scheduled_payments#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/scheduled_payments').to route_to('scheduled_payments#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/scheduled_payments/1').to route_to('scheduled_payments#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/scheduled_payments/1').to route_to('scheduled_payments#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/scheduled_payments/1').to route_to('scheduled_payments#destroy', id: '1')
    end
  end
end
