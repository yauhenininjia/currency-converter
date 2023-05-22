describe ExchangeRatesFetcher do
  include_context 'with cache'

  describe '#call' do
    let(:mocked_response) do
      {
        time_next_update_unix: Time.now.to_i + 60_000,
        rates: {
          EUR: 1,
          USD: 1.08
        }
      }
    end

    before do
      WebMock
        .stub_request(:get, 'http://open.er-api.com/v6/latest/EUR')
        .to_return(
          headers: { 'Content-type' => 'application/json' },
          body: mocked_response.to_json
        )

      allow(described_class).to receive(:get).and_call_original
    end

    subject { described_class.new('EUR').call }

    context 'when rates are not cached yet' do
      it 'fetches rates from external api' do
        expect(described_class).to receive(:get).with('/EUR')
        expect(subject).to eq({
          'EUR' => 1,
          'USD' => 1.08
        })
      end
    end

    context 'when rates are already cached' do
      before { described_class.new('EUR').call }

      it 'does not call external api again' do
        expect(described_class).to_not receive(:get)
        described_class.new('EUR').call
      end
    end
  end
end
