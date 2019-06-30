# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Validators::Tickets::AllTogether do
  let(:instance) { described_class.new(reserved, available) }

  describe '.validate' do
    context 'enough tickets available' do
      let(:reserved)  { 2 }
      let(:available) { 2 }

      it 'retuns empty array of errors' do
        expect(instance.validate).to eq([])
      end
    end

    context 'not enough tickets available' do
      let(:reserved)  { 2 }
      let(:available) { 0 }

      it 'retuns errors' do
        expect(instance.validate).to eq(
          ["We haven't got enough 'all_together' tickets available"]
        )
      end
    end

    context 'user want to order only a part of all_together tickets' do
      let(:reserved)  { 7 }
      let(:available) { 10 }

      it 'retuns errors' do
        expect(instance.validate).to eq(
          ["You have to reserve all tickets of that type"]
        )
      end
    end
  end
end
