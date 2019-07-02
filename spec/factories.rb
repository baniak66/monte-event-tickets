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

  factory :reservation do
    event
    user
  end

  factory :user do
    email    { 'test@email.net' }
    password { 'password' }
  end

  factory :payment do
    reservation
    amount   { 100 }
    currency { 'EUR' }
  end
end
