# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Actions::Response::Success do
  describe 'success?' do
    it 'returns true' do
      expect(described_class.new.success?).to be_truthy
    end
  end
end
