# frozen_string_literal: true

class Ticket < ApplicationRecord
  belongs_to :event
  belongs_to :reservation
end
