# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Nomics::Api do
  subject(:api) { described_class.new }

  describe '#get_crypto_by_ticker' do
    subject(:response) { api.get_crypto_by_ticker(ids: ids) }

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

  describe '#convert_crypto' do
    subject(:converted_crypto) { api.convert_crypto(currency: currency, ids: id) }

    let(:currency) { 'ZAR' }
    let(:id) { ['BTC'] }

    context 'when ticker is valid' do
      it 'swap crypto', :aggregate_failures, vcr: { cassette_name: 'convert_crypto' } do
        expect(converted_crypto).not_to be_empty
        expect(converted_crypto[0]['id']).to eq 'BTC'
      end
    end
  end
end
