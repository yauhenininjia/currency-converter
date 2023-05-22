describe ConverterController do
  describe '#convert' do
    let(:from_currency) { 'EUR' }
    let(:to_currency) { 'USD' }
    let(:amount) { '100' }
    let(:converted_amount) { 6 }

    subject { response.body }

    context 'when rate is found' do
      before do
        allow_any_instance_of(CurrencyConverter).to receive(:call).and_return(converted_amount)

        get(:convert, params: { from_currency: from_currency, to_currency: to_currency, amount: amount })
      end


      context 'when params are valid' do
        it 'responds with converted amount' do
          expect(subject).to eq({ converted_amount: converted_amount }.to_json)
        end
      end

      context 'when params are invalid' do
        %i[from_currency to_currency amount].each do |param|
          context "when #{param} is empty" do
            let(param) { nil }

            it 'responds with error' do
              expect(subject).to eq({ error: 'Required param is missing' }.to_json)
            end
          end
        end

        context 'when amount is not a number' do
          let(:amount) { 'not-a-number' }

          it 'responds with error' do
            expect(subject).to eq({ error: 'Invalid amount' }.to_json)
          end
        end

        context 'when amount is negative' do
          let(:amount) { '-100' }

          it 'responds with error' do
            expect(subject).to eq({ error: 'Invalid amount' }.to_json)
          end
        end
      end
    end

    context 'when rate is not found' do
      before do
        allow_any_instance_of(CurrencyConverter).to receive(:call).and_raise(ExchangeRate::ExchangeRateNotFound)

        get(:convert, params: { from_currency: from_currency, to_currency: to_currency, amount: amount })
      end

      it 'responds with error' do
        expect(subject).to eq({ error: 'Exchange rate not found' }.to_json)
      end
    end
  end
end
