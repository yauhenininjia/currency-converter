class ExchangeRate
  class ExchangeRateNotFound < StandardError; end

  def initialize(from_currency, to_currency)
    @from_currency = from_currency
    @to_currency = to_currency
  end

  def call
    rates.fetch(to_currency) { raise ExchangeRateNotFound }
  end

  private

  attr_reader :from_currency, :to_currency

  def rates
    ExchangeRatesFetcher.new(from_currency).call
  end
end
