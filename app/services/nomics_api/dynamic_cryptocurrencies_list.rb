# frozen_string_literal: true

require 'monads'

module NomicsApi
  # Makes a request to the Nomics API.
  # Used to get specific crypto and specific values based on the given tickers and any other dynamic params
  # @note use cautiously, since it makes an external api call - use it in a background job
  class DynamicCryptocurrenciesList
    # @param tickers [<[String]>] cryptocurrencies ticker symbols
    # @param values [<[String]>] dynamic params for
    def initialize(tickers:, values:)
      @tickers = tickers
      @values = values
    end

    # Method to call the service object.
    #
    # @return [Success<[Hash]>] monad with an array of hashes
    # @return [Failure<String>] if error has occurred.
    def call
      call_api
        .bind(method(:transform_response))
    end

    attr_reader :tickers, :values

    private

    def call_api
      response = api.get_crypto_by_ticker(ids: tickers)

      if response.present?
        Success(response)
      else
        Failure(response)
      end
    end

    def transform_response(response)
      Success(response.map { |entry| entry.slice(*values) })
    end

    def api
      @api ||= ::Nomics::Api.new
    end
  end
end
