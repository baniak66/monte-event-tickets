# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Validators::ReservationTicketsQuantity do
  describe 'validate' do
    let(:tickets_quantity) do
      {
        even:         ordered_even,
        all_together: ordered_all_together,
        avoid_one:    ordered_avoid_one
      }
    end
    let(:availiavle_tickets) do
      {
        "even"         => [{ "quantity" => available_even }],
        "all_together" => [{ "quantity" => available_all_together }],
        "avoid_one"    => [{ "quantity" => available_avoid_one }]
      }
    end
    let(:ordered_even)           { 2 }
    let(:ordered_all_together)   { 3 }
    let(:ordered_avoid_one)      { 5 }
    let(:available_even)         { 2 }
    let(:available_all_together) { 3 }
    let(:available_avoid_one)    { 5 }
    let(:instance) { described_class.new(tickets_quantity, availiavle_tickets) }

    it 'uses prpoper ticket type validators' do
      even_validator         = instance_double('Validators::Tickets::Even')
      all_together_validator = instance_double('Validators::Tickets::AllTogether')
      avoid_one_validator    = instance_double('Validators::Tickets::AvoidOne')

      expect(Validators::Tickets::Even).to receive(:new).and_return(even_validator)
      expect(Validators::Tickets::AllTogether).to receive(:new).and_return(all_together_validator)
      expect(Validators::Tickets::AvoidOne).to receive(:new).and_return(avoid_one_validator)
      expect(even_validator).to receive(:validate).and_return('even_validator_error')
      expect(all_together_validator).to receive(:validate).and_return('all_together_validator_error')
      expect(avoid_one_validator).to receive(:validate).and_return('avoid_one_validator_error')

      expect(instance.validate).to match_array(
        %w[even_validator_error all_together_validator_error avoid_one_validator_error]
      )
    end

    context 'all tickets quantity valid' do
      it 'returns empty errors array' do
        expect(instance.validate).to match_array([])
      end
    end

    context 'only one type of ticket reserved' do
      let(:ordered_even)     { 1 }
      let(:available_even)   { 2 }
      let(:tickets_quantity) { { even: ordered_even } }

      it 'validators works and returns error message' do
        expect(instance.validate).to match_array(
          ["You have to reserve even number of tickets"]
        )
      end
    end

    context 'user order 1 ticket from even type' do
      let(:ordered_even) { 1 }

      it 'returns error message' do
        expect(instance.validate).to match_array(
          ["You have to reserve even number of tickets"]
        )
      end
    end

    context 'last 2 avoid_one tickets left' do
      let(:available_avoid_one) { 2 }

      context 'user order 1 avoid_one ticket' do
        let(:ordered_avoid_one) { 1 }

        it 'returns error message' do
          expect(instance.validate).to match_array(
            ["You have to add one more 'avoid_one' ticket to complete reservation"]
          )
        end
      end
    end

    context 'all_together tickets' do
      let(:available_all_together) { 20 }

      context 'user order less than all all_together tickets' do
        let(:ordered_all_together) { 14 }

        it 'returns error message' do
          expect(instance.validate).to match_array(
            ["You have to reserve all tickets of that type"]
          )
        end
      end
    end

    context 'all validators failed' do
      let(:ordered_even)           { 1 }
      let(:ordered_all_together)   { 2 }
      let(:ordered_avoid_one)      { 1 }
      let(:available_even)         { 2 }
      let(:available_all_together) { 3 }
      let(:available_avoid_one)    { 0 }

      it 'returns all validators errors array' do
        expect(instance.validate).to match_array(
          [
            "You have to reserve all tickets of that type",
            "We haven't got enough 'avoid_one' tickets available",
            "You have to reserve even number of tickets"
          ]
        )
      end
    end
  end
end
