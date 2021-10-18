# frozen_string_literal: true

module Nomics
  # Client for the Nomics API
  class Client
    include ::Errors

    API_ENDPOINT = 'https://api.nomics.com/v1/'
    API_KEY = Rails.application.credentials[:nomics][:api_key]

    def initialize
      @access_token = API_KEY
    end

    # Get method used to create get request for given path and options
    #
    # @param path [String] the path for request
    # @param options [Hash] custom query params for request
    # @return [<[Hash]>]
    def get(path, options = {})
      handle_response(client.public_send(:get, path.to_s, options))
    end

    attr_reader :access_token

    private

    def client
      @client =
        Faraday.new(API_ENDPOINT) do |client|
          client.request :url_encoded
          client.response :json, content_type: /\bjson$/
          client.adapter Faraday.default_adapter
          client.headers['Accept'] = 'application/json'
          client.headers['Content-Type'] = 'application/json'
          client.headers['Authorization'] = "Bearer #{access_token}"
        end
    end

    def handle_response(response)
      return response_body(response) if response.success?

      raise error_class(response.status)
    end

    def response_body(response)
      return if response.body.empty?

      response.body
    end
  end
end
