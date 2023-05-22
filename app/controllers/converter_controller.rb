class ConverterController < ApplicationController
  class InvalidAmountError < StandardError; end

  rescue_from ExchangeRate::ExchangeRateNotFound, with: -> { render json: { error: 'Exchange rate not found' } }
  rescue_from ActionController::ParameterMissing, with: -> { render json: { error: 'Required param is missing' } }
  rescue_from InvalidAmountError, with: -> { render json: { error: 'Invalid amount' } }

  before_action :validate_amount

  def convert
    converted_amount = CurrencyConverter.new(from_currency, to_currency, amount).call

    render json: { converted_amount: converted_amount }
  end

  private

  def validate_amount
    return true if amount =~ /^\d+/

    raise InvalidAmountError
  end

  def from_currency
    params.require(:from_currency)
  end

  def to_currency
    params.require(:to_currency)
  end

  def amount
    params.require(:amount)
  end
end
