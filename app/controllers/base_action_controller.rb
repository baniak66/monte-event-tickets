# frozen_string_literal: true

class BaseActionController < ApplicationController
  before_action :authenticate_user!

  def create
    action_response = action.call
    if action_response.success?
      head :ok
    else
      render json: Oj.dump(action_response.result, mode: :rails), status: :unprocessable_entity
    end
  end
end
