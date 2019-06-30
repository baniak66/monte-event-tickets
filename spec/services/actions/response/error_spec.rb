# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Actions::Response::Error do
  describe 'success?' do
    it 'returns false' do
      expect(described_class.new.success?).to be_falsey
    end
  end
end
