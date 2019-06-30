# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Validators::Tickets::AvoidOne do
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
          ["We haven't got enough 'avoid_one' tickets available"]
        )
      end
    end

    context 'user want to order only 1 of 2 left avoid_one tickets' do
      let(:reserved)  { 1 }
      let(:available) { 2 }

      it 'retuns errors' do
        expect(instance.validate).to eq(
          ["You have to add one more 'avoid_one' ticket to complete reservation"]
        )
      end
    end
  end
end
