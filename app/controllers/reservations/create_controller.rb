# frozen_string_literal: true

module Reservations
  class CreateController < ApplicationController
    before_action :authenticate_user!

    def create
      head :ok
    end
  end
end
