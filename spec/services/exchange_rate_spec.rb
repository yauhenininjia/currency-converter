describe ExchangeRate do
  describe 'call' do
    let(:exchange_rates_fetcher) { double(:exchange_rates_fetcher) }
    let(:from_currency) { 'EUR' }
    let(:to_currency) { 'USD' }

    before do
      allow(ExchangeRatesFetcher).to receive(:new).with(from_currency).and_return(exchange_rates_fetcher)
      allow(exchange_rates_fetcher).to receive(:call).and_return(exchange_rates)
    end

    subject { described_class.new(from_currency, to_currency).call }

    context 'when exchange rate exist' do
      let(:exchange_rates) { { 'USD' => 1.08 } }

      it 'finds exchange rate' do
        expect(subject).to eq(1.08)
      end
    end

    context 'when exchange rate does not exist' do
      let(:exchange_rates) { { 'GBP' => 1.08 } }

      it 'raises error' do
        expect { subject }.to raise_error(ExchangeRate::ExchangeRateNotFound)
      end
    end
  end
end
