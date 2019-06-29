# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  let(:event) { create :event }

  it 'responds with 200' do
    get :show, params: { id: event.id }
    expect(response).to have_http_status :ok
  end
end
