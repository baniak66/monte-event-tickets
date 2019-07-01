# frozen_string_literal: true

module Reservations
  class ShowController < ApplicationController
    before_action :authenticate_user!

    def show
      render json: Oj.dump(serialized_reservation, mode: :rails)
    end

    private

    def serialized_reservation
      {}
    end
  end
end
