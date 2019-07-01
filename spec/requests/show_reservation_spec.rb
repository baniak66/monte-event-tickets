# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Show reservation', type: :request do
  context 'logged user' do
    include_context 'user_token_authentication'

    let(:event)       { create :event }
    let(:reservation) { create :reservation, event: event, user: user }

    it 'responds with 200' do
      get reservations_show_path(reservation.id), headers: user_auth_headers
      expect(response).to have_http_status :ok
    end
  end

  context 'not logged user' do
    it 'responds with 401' do
      get reservations_show_path(1)
      expect(response).to have_http_status 401
    end
  end
end
