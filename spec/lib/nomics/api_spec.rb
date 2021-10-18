# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Nomics::Api do
  describe '#get_crypto_by_ticker' do
    subject(:response) { described_class.new.get_crypto_by_ticker(ids: ids) }

    context 'when ticker is valid' do
      let(:ids) { %w[BTC XRP ETH] }

      it 'fetch all cryptos', :aggregate_failures, vcr: { cassette_name: 'get_crypto_by_ticker' } do
        expect(response.size).to eq 3
        expect(response).not_to be_empty
      end
    end

    context 'when ticker is invalid' do
      let(:ids) { ['dunder_mifflin_coin'] }

      it 'does not return body', :aggregate_failures, vcr: { cassette_name: 'invalid_ticker' } do
        expect(response).to be_nil
      end
    end
  end
end
