class CurrencyConverter
  def initialize(from_currency, to_currency, amount)
    @from_currency = from_currency
    @to_currency = to_currency
    @amount = BigDecimal(amount.to_s)
  end

  def call
    amount * exchange_rate
  end

  private

  attr_reader :from_currency, :to_currency, :amount

  def exchange_rate
    rate = ExchangeRate.new(from_currency, to_currency).call
    BigDecimal(rate.to_s)
  end
end
