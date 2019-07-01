# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Create reservation', type: :request do
  let(:event) { create :event }

  context 'logged user' do
    include_context 'user_token_authentication'

    let(:request_params) do
      {
        event_id:     event.id,
        even:         2,
        all_together: 3,
        avoid_one:    1
      }
    end
    let(:create_action) { instance_double('Actions::CreateReservation') }

    before do
      allow(::Actions::CreateReservation).to receive(:new).and_return(create_action)
      allow(create_action).to receive(:call).and_return(action_response)
    end

    context 'action success' do
      let(:action_response) { instance_double('Actions::Response::Success', success?: true) }

      it 'responds with 200' do
        post reservations_create_path, params: {}, headers: user_auth_headers
        expect(response).to have_http_status :ok
      end

      it 'uses proper action and params to create reservation' do
        expect(::Actions::CreateReservation)
          .to receive(:new)
          .with(
            user:             user,
            event_id:         event.id.to_s,
            tickets_quantity: {
              even:         '2',
              all_together: '3',
              avoid_one:    '1'
            }
          )
          .and_return(create_action)
        expect(create_action).to receive(:call).and_return(action_response)

        post reservations_create_path, params: request_params, headers: user_auth_headers
      end
    end

    context 'action failed' do
      let(:action_response) { instance_double('Actions::Response::Error', success?: false, result: result) }
      let(:result) { { errors: 'realy_bad_error' } }

      it 'responds with 422' do
        post reservations_create_path, params: {}, headers: user_auth_headers
        expect(response).to have_http_status 422
      end

      it 'renders json with errors' do
        post reservations_create_path, params: {}, headers: user_auth_headers
        expect(Oj.load(response.body)).to eq('errors' => 'realy_bad_error')
      end
    end
  end

  context 'integration test' do
    include_context 'user_token_authentication'

    before { create_list :ticket, 2, event: event, ticket_type: 'even' }

    context 'reservation valid' do
      let(:request_params) do
        {
          event_id: event.id,
          even:     2
        }
      end

      it 'responds with success' do
        post reservations_create_path, params: request_params, headers: user_auth_headers
        expect(response).to have_http_status :ok
      end
    end

    context 'reservation invalid' do
      let(:request_params) do
        {
          event_id:     event.id,
          even:         1,
          all_together: 2
        }
      end

      it 'responds with 422 status' do
        post reservations_create_path, params: request_params, headers: user_auth_headers
        expect(response).to have_http_status 422
      end

      it 'responds with error json' do
        even_error         = "You have to reserve even number of tickets"
        all_together_error = "We haven't got enough 'all_together' tickets available"
        post reservations_create_path, params: request_params, headers: user_auth_headers
        expect(Oj.load(response.body)).to eq(
          "errors" => [even_error, all_together_error].join('. ')
        )
      end
    end
  end

  context 'not logged user' do
    it 'responds with 200' do
      post reservations_create_path, params: {}
      expect(response).to have_http_status 401
    end
  end
end
