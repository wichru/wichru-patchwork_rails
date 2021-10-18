# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Nomics::Client do
  subject(:client) { described_class.new }

  let(:body) { { some: 'json' }.to_json }
  let(:status) { 200 }

  before { stub_request(:any, /test/).to_return(body: body, status: status) }

  describe '#get' do
    it 'makes Get request to api endpoint' do
      client.send(:get, 'test')
      expect(a_request(:get, 'https://api.nomics.com/v1/test')).to have_been_made.once
    end
  end

  describe 'response handling' do
    subject(:response) { client.get('test') }

    context 'when correct response' do
      let(:status) { 200 }

      it 'returns correct response object' do
        expect(response).to eq body
      end
    end

    context 'when client error' do
      let(:status) { 404 }

      it 'raises NotFoundError' do
        expect { response }.to raise_error(Errors::NotFoundError)
      end
    end

    context 'when unauthorized' do
      let(:status) { 401 }

      it 'raises UnauthorizedError' do
        expect { response }.to raise_error(Errors::UnauthorizedError)
      end
    end

    context 'when server error' do
      let(:status) { 500 }

      it 'raises ApiError' do
        expect { response }.to raise_error(Errors::ApiError)
      end
    end
  end
end
