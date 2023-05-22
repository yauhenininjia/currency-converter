class ExchangeRatesFetcher
  BASE_URI = 'open.er-api.com/v6/latest'.freeze

  include HTTParty

  base_uri BASE_URI

  def initialize(currency)
    @currency = currency
  end

  def call
    rates = Rails.cache.read(cache_key)

    return rates if rates.present?

    Rails.cache.write(cache_key, response_rates, expires_in: expires_in)

    response_rates
  end

  private

  attr_reader :currency

  def cache_key
    @cache_key ||= "EXCHANGE_RATES_#{currency}"
  end

  def response
    @response ||= self.class.get("/#{currency}")
  end

  def response_rates
    @response_rates ||= response.fetch('rates', {})
  end

  def response_expires_in
    response.fetch('time_next_update_unix', Time.now.to_i)
  end

  def expires_in
    response_expires_in - Time.now.to_i
  end
end
