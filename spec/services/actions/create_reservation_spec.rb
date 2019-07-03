# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Actions::CreateReservation do
  let(:user)            { create :user }
  let(:event)           { create :event }
  let(:event_2)         { create :event }
  let(:ordered_tickets) { { avoid_one: 1 } }
  let(:instance) { described_class.new(user: user, event_id: event.id, tickets_quantity: ordered_tickets) }

  describe 'call' do
    before do
      create_list :ticket, 3, event: event, ticket_type: 'avoid_one'
      create_list :ticket, 4, event: event_2, ticket_type: 'avoid_one'
      create_list :ticket, 2, event: event, ticket_type: 'even'

      validator = instance_double('Validators::ReservationTicketsQuantity')
      allow(Validators::ReservationTicketsQuantity).to receive(:new).and_return(validator)
      allow(validator).to receive(:validate).and_return(errors_array)
    end

    context 'action successful' do
      let(:errors_array) { [] }

      it 'creates new reservation with proper event and assaign ticket' do
        instance.call
        reservation = user.reservations.first

        expect(user.reservations.count).to eq 1
        expect(reservation.event_id).to eq event.id
        expect(reservation.tickets.count).to eq 1
      end

      it 'validates quantity of ordered tickets' do
        validator = instance_double('Validators::ReservationTicketsQuantity')
        expect(Validators::ReservationTicketsQuantity)
          .to receive(:new)
          .with(ordered_tickets, kind_of(Hash))
          .and_return(validator)
        expect(validator).to receive(:validate).and_return(errors_array)

        instance.call
      end

      it 'returns success response object' do
        expect(instance.call).to be_instance_of(Actions::Response::Success)
      end

      it 'triggers release reservation job' do
        release_reservation_job = class_double('ReleaseReservationJob')
        expect(ReleaseReservationJob).to receive(:set)
          .with(wait: 15.minutes).and_return(release_reservation_job)
        expect(release_reservation_job).to receive(:perform_later)
          .with(kind_of(Integer))

        instance.call
      end
    end

    context 'action failed' do
      context 'validation failed' do
        let(:errors_array) { ['realy_bad_error'] }

        it 'returns error response object' do
          expect(instance.call).to be_instance_of(Actions::Response::Error)
        end
      end

      context 'transaction failed' do
        shared_examples_for 'rollbacked_transaction' do
          let(:errors_array) { [] }

          it "dosen't update tickets reservation" do
            expect(user.reservations.count).to eq 0
            expect(event.tickets.where(reservation_id: nil).count).to eq 5 # all event tickets
          end

          it 'returns error response object' do
            expect(instance.call).to be_instance_of(Actions::Response::Error)
          end
        end

        context 'reservation create failed' do
          before do
            allow(Reservation).to receive(:create).and_return(false)
            instance.call
          end

          it_behaves_like 'rollbacked_transaction'
        end

        context 'tickets update raise error' do
          before do
            allow(Ticket).to receive(:where).and_raise(ActiveRecord::Rollback)
            instance.call
          end

          it_behaves_like 'rollbacked_transaction'
        end
      end
    end
  end
end
