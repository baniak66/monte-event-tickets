# frozen_string_literal: true

class EventsController < ApplicationController
  def show
    if event
      render json: Oj.dump(serialized_event, mode: :rails)
    else
      head :unprocessable_entity
    end
  end

  private

  def serialized_event
    ::Serializers::EventTickets.new(event, available_tickets).serialize
  end

  def available_tickets
    ::Repository::EventAvailableTickets.call(event.id)
  end

  def event
    @event ||= Event.find_by(id: params[:id])
  end
end
