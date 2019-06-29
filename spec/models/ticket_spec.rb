# frozen_string_literal: true

# == Schema Information
#
# Table name: tickets
#
#  id             :bigint           not null, primary key
#  price          :integer          not null
#  ticket_type    :enum             not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  event_id       :bigint           not null
#  reservation_id :bigint
#
# Indexes
#
#  index_tickets_on_event_id  (event_id)
#
# Foreign Keys
#
#  fk_rails_...  (event_id => events.id)
#

require 'rails_helper'

RSpec.describe Ticket, type: :model do
  let(:event)         { create :event }
  let(:ticket_params) { { event: event, price: 1000, ticket_type: type } }

  describe 'associations' do
    it { is_expected.to belong_to(:event) }
  end

  describe 'validators' do
    it { is_expected.to validate_presence_of :price }
    it { is_expected.to validate_presence_of :ticket_type }

    context 'ticket type' do
      context 'form supported types list' do
        let(:type) { 'even' }

        it 'is valid' do
          new_ticket = described_class.new(ticket_params)

          expect(new_ticket).to be_valid
        end
      end

      context 'not form supported types list' do
        let(:type) { 'invalid_type' }

        it 'is invalid' do
          new_ticket = described_class.new(ticket_params)

          expect(new_ticket).to be_invalid
        end
      end
    end
  end
end
