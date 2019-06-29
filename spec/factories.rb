# frozen_string_literal: true

require 'factory_bot'

FactoryBot.define do
  factory :event do
    name { 'Event name' }
    date { Date.current.noon + 1.day }
  end

  factory :ticket do
    event
    ticket_type { 'avoid_one' }
    price       { 100 }
  end
end
