# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NomicsApi::CalculatePrice, type: :service do
  describe '#call' do
    subject { described_class.new(primary: primary, sub: sub).call }

    let(:primary) { 'BTC' }
    let(:sub) { 'ETH' }
    let(:expected_result) { '1ETH == 0.06BTC' }

    context 'when tickers and values are valid' do
      it 'returns expected array of hashes', :aggregate_failures, vcr: { cassette_name: 'success_calculate_price' } do
        expect(subject).to eq Success(expected_result)
      end
    end

    context 'when ticker is not valid' do
      let(:primary) { ['some_coin_two'] }
      let(:sub) { ['some_coin'] }

      it 'raises failure', :aggregate_failures, vcr: { cassette_name: 'failure_calculate_price' } do
        expect(subject).to eq Failure(nil)
      end
    end
  end
end
