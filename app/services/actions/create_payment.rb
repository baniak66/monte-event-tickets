# frozen_string_literal: true

module Actions
  class CreatePayment
    def initialize(reservation_id:, amount:, token:)
      @reservation_id = reservation_id
      @amount         = amount
      @token          = token
    end

    # :reek:DuplicateMethodCall
    def call
      process_payment
    rescue Adapters::Payment::Gateway::CardError => error
      error_response(error.message)
    rescue Adapters::Payment::Gateway::PaymentError => error
      error_response(error.message)
    end

    private

    attr_reader :reservation_id, :amount, :token

    def process_payment
      payment = Payment.create(
        reservation_id: reservation_id,
        amount:         charge_result.amount,
        currency:       charge_result.currency
      )
      payment.persisted? ? Actions::Response::Success.new : error_response("Error occured")
    end

    def charge_result
      @charge_result ||= Adapters::Payment::Gateway.charge(amount: amount, token: token)
    end

    # :reek:UtilityFunction
    def error_response(error)
      Actions::Response::Error.new(result: { errors: error })
    end
  end
end
