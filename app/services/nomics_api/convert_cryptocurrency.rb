# frozen_string_literal: true

require 'monads'

module NomicsApi
  # Makes a request to the Nomics API.
  # Used to get convert specific crypto to fiat and returns full payload in defined fiat
  # @example
  #   BTC in Zar
  #   ETH in USD
  # @note use cautiously, since it makes an external api call - use it in a background job
  class ConvertCryptocurrency
    # @param ticker [<[String]>] cryptocurrency ticker symbol
    # @param fiat [<String>] currency symbol it is converted to
    def initialize(ticker:, fiat:)
      @ticker = ticker
      @fiat = fiat
    end

    # Method to call the service object.
    #
    # @return [Success<[Hash]>] monad with an array of hashes
    # @return [Failure<String>] if error has occurred.
    def call
      response = api.convert_crypto(currency: fiat, ids: ticker)

      if response.present?
        Success(response)
      else
        Failure(response)
      end
    end

    attr_reader :ticker, :fiat

    private

    def api
      @api ||= ::Nomics::Api.new
    end
  end
end
