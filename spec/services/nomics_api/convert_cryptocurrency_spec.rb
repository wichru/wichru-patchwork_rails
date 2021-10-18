# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NomicsApi::ConvertCryptocurrency, type: :service do
  describe '#call' do
    subject { described_class.new(ticker: ticker, fiat: fiat).call }

    let(:ticker) { %w[BTC] }
    let(:fiat) { 'ZAR' }
    let(:api_response) do
      "Success([{ 'id' => 'BTC',
                 'currency' => 'BTC',
                 'symbol' => 'BTC',
                 'name' => 'Bitcoin',
                 'market_cap_change' => '373245773000.37',
                 'market_cap_change_pct' => '0.0223' }])"
    end

    before do
      stub_request(:get, 'https://api.nomics.com/v1/currencies/ticker?convert=ZAR&ids=BTC').to_return(
        status: 200, body: api_response, headers: {}
      )
    end

    it 'returns an array of hashes' do
      expect(subject.value!).to eq(api_response)
    end

    context 'when it does not pass validations' do
      let(:api_response) { nil }

      it 'raises failure' do
        expect(subject).to eq Failure(nil)
      end
    end
  end
end
