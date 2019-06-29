# frozen_string_literal: true

# == Schema Information
#
# Table name: events
#
#  id         :bigint           not null, primary key
#  date       :datetime         not null
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Event, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:tickets) }
  end

  describe 'validators' do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :date }
  end
end
