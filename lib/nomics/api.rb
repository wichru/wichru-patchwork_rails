# frozen_string_literal: true

module Nomics
  # Nomics API wrapper class to get in to specific endopint
  class Api
    # Get the full payload of cryptocurrencies defined by ids [<[String]>]
    #
    # @param ids [<[String]>] cryptocurrencies ticker symbols
    # @return [<[Hash]>] with full payload
    def get_crypto_by_ticker(ids: [])
      client.get('currencies/ticker', { ids: ids.join(',') })
    end

    # Get the full payload of cryptocurrencies defined by ids [<[String]>] exchanged to given currency [<String>]
    #
    # @param currency [<String>] the symbol of the currency or fiat to be exchanged
    # @param ids [<[String]>] cryptocurrencies ticker symbols
    # @return [<[Hash]>] with full payload
    def convert_crypto(currency:, ids: [])
      client.get('currencies/ticker', { convert: currency.to_s, ids: ids.join(',') })
    end

    private

    def client
      @client ||= Nomics::Client.new
    end
  end
end
