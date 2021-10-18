# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NomicsApi::DynamicCryptocurrenciesList, type: :service do
  describe '#call' do
    subject { described_class.new(tickers: tickers, values: values).call }

    let(:tickers) { %w[BTC ETH] }
    let(:values) { %w[name symbol] }
    let(:api_response) do
      "[
        {
          'id' => 'BTC',
          'currency' => 'BTC',
          'price' => '62343.3934',
          'symbol' => 'BTC',
          'name' => 'Bitcoin',
          'market_cap_change' => '554547614995.75',
          'market_cap_change_pct' => '0.9074'
        },
        {
          'id' => 'ETH',
          'currency' => 'ETH',
          'price' => '3865.83593655',
          'symbol' => 'ETH',
          'name' => 'Ethereum',
          'market_cap_change' => '123.75',
          'market_cap_change_pct' => '0.9074'
        }
      ]"
    end
    let(:expected_result) do
      [
        { 'name' => 'Bitcoin', 'symbol' => 'BTC' },
        { 'name' => 'Ethereum', 'symbol' => 'ETH' }
      ]
    end

    context 'when tickers and values are valid' do
      it 'returns expected array of hashes', :aggregate_failures, vcr: { cassette_name: 'success_dynamic_list' } do
        expect(subject).to eq Success(expected_result)
      end
    end

    context 'when ticker is not valid' do
      let(:tickers) { ['some_coin'] }

      it 'raises failure', :aggregate_failures, vcr: { cassette_name: 'failure_dynamic_list' } do
        expect(subject).to eq Failure(nil)
      end
    end
  end
end
