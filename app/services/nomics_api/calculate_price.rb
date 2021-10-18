# frozen_string_literal: true

require 'monads'

module NomicsApi
  # Makes a request to the Nomics API.
  # Used to calculate price of one crypto from another in relation to their dollar value
  # @example
  #   BTC = $100USD, 1ETH = $50, therefore 1ETH == 0.5BTC
  # @note use cautiously, since it makes an external api call - use it in a background job
  class CalculatePrice
    # @param primary [<String>] primary cryptocurrency ticker symbol
    # @param sub [<String>] sub cryptocurrency ticker symbol
    def initialize(primary:, sub:)
      @primary = primary
      @sub = sub
    end

    # Method to call the service object.
    #
    # @return [Success<[Hash]>] monad with an array of hashes
    # @return [Failure<String>] if error has occurred.
    def call
      call_api
        .bind(method(:cleanup_response))
        .bind(method(:calculate_price))
        .bind(method(:print_result))
    end

    attr_reader :primary, :sub

    private

    def call_api
      response = api.get_crypto_by_ticker(ids: build_ids)

      if response.present?
        Success(response)
      else
        Failure(response)
      end
    end

    def cleanup_response(response)
      Success(response.map { |entry| entry.slice('id', 'price') })
    end

    def calculate_price(response)
      primary_coin_hash = response.find { |hash| hash['id'] == primary }
      sub_coin_hash = response.find { |hash| hash['id'] == sub }

      result = (sub_coin_hash['price'].to_f / primary_coin_hash['price'].to_f).round(2)

      Success(result)
    end

    def print_result(result)
      Success("1#{sub} == #{result}#{primary}")
    end

    def build_ids
      "#{primary} #{sub}".split
    end

    def api
      @api ||= ::Nomics::Api.new
    end
  end
end
