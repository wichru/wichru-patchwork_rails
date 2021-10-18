# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NomicsApi::DynamicCryptocurrenciesList, type: :service do
  describe '#call' do
    subject { described_class.new(tickers: tickers, values: values).call }

    let(:tickers) { %w[BTC ETH] }
    let(:values) { %w[name symbol] }
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
