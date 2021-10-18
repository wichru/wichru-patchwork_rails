# frozen_string_literal: true

require 'monads'

module NomicsApi
  # Makes a request to the Nomics API with static params.
  # Used to get whole list of Cryptocurrencies payload for given tickers
  # @note use cautiously, since it makes an external api call - use it in a background job
  class GetCryptocurrenciesList
    # @param tickers [<[String]>] cryptocurrencies ticker symbols
    def initialize(tickers:)
      @tickers = tickers
    end

    # Method to call the service object.
    #
    # @return [Success<[Hash]>] monad with an array of hashes - hashes are returned for performance reasons
    # @return [Failure<String>] if error has occurred.
    def call
      response = api.get_crypto_by_ticker(ids: tickers)

      if response.present?
        Success(response)
      else
        Failure(response)
      end
    end

    attr_reader :tickers

    private

    def api
      @api ||= ::Nomics::Api.new
    end
  end
end
