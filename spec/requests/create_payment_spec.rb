# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Create payment', type: :request do
  let(:event)       { create :event }
  let(:reservation) { create :reservation, event: event, user: user }

  let(:request_params) do
    {
      id:     reservation.id,
      amount: 1000
    }
  end

  context 'logged user' do
    include_context 'user_token_authentication'

    let(:create_action) { instance_double('Actions::CreatePayment', call: action_response) }

    before do
      user.payment_token = 'valid_token'
      user.save
    end

    context 'stubbed action' do
      before do
        allow(::Actions::CreatePayment).to receive(:new).and_return(create_action)
      end

      context 'action success' do
        let(:action_response) { instance_double('Actions::Response::Success', success?: true) }

        it 'responds with 200' do
          post payments_create_path, params: request_params, headers: user_auth_headers, as: :json
          expect(response).to have_http_status :ok
        end

        it 'uses proper action to create payment' do
          expect(::Actions::CreatePayment)
            .to receive(:new)
            .with(
              reservation_id: reservation.id,
              amount:         1000,
              token:          user.payment_token
            )
            .and_return(create_action)
          expect(create_action).to receive(:call).and_return(action_response)

          post payments_create_path, params: request_params, headers: user_auth_headers, as: :json
        end
      end

      context 'action failed' do
        let(:action_response) { instance_double('Actions::Response::Error', success?: false, result: 'err') }

        it 'responds with 422 status' do
          post payments_create_path, params: request_params, headers: user_auth_headers, as: :json
          expect(response).to have_http_status 422
        end
      end
    end

    context 'integration test' do
      it 'responds with 200' do
        post payments_create_path, params: request_params, headers: user_auth_headers, as: :json
        expect(response).to have_http_status :ok
      end
    end
  end

  context 'not logged user' do
    it 'responds with 401' do
      post payments_create_path, params: {}
      expect(response).to have_http_status 401
    end
  end
end
