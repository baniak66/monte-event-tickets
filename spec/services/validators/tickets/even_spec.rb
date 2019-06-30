# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Validators::Tickets::Even do
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
          ["We haven't got enough 'even' tickets available"]
        )
      end
    end

    context 'user want to order odd number of tickets' do
      let(:reserved)  { 3 }
      let(:available) { 10 }

      it 'retuns errors' do
        expect(instance.validate).to eq(
          ["You have to reserve even number of tickets"]
        )
      end
    end
  end
end
