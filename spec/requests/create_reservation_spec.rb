# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Create reservation', type: :request do
  context 'logged user' do
    include_context 'user_token_authentication'

    it 'responds with 200' do
      post reservations_create_path, params: {}, headers: user_auth_headers
      expect(response).to have_http_status :ok
    end
  end
end
