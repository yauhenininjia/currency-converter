describe CurrencyConverter do
  describe '#call' do
    let(:exchange_rate_service) { double(:exchange_rate_service) }
    let(:exchange_rate) { 1.5 }

    before do
      allow(ExchangeRate).to receive(:new).with('EUR', 'USD').and_return(exchange_rate_service)
      allow(exchange_rate_service).to receive(:call).and_return(exchange_rate)
    end

    subject { described_class.new('EUR', 'USD', 12).call }

    it 'converts EUR to USD' do
      expect(subject).to eq(BigDecimal('18'))
    end
  end
end
