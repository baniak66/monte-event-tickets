# frozen_string_literal: true

class Payment < ApplicationRecord
  belongs_to :reservation
end
