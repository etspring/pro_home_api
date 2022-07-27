require 'httparty'

module ProHome
  module Api
    class Client
      attr_reader :bearer, :headers

      %w[codeconfirm counter counters_history dependencies polls registration].each do |method_name|
        define_method(method_name) do |data: {}|
          post(endpoint: __method__.to_s.split('_').join('/'), payload: data)
        end
      end

      def initialize(options = {})
        @bearer    = options[:bearer] || ''
        @headers = { 'Authorization': @bearer, 'User-Agent': 'CadiaStands! 0.1',
                     'Content-Type': 'application/json' }
      end

      private

      def url(endpoint = '')
        "https://gw.prohome.ru/api/v1/uk/#{endpoint}"
      end

      def get(endpoint:)
        HTTParty.get(url(endpoint), headers: @headers).parsed_response
      end

      def post(endpoint:, payload: {})
        HTTParty.post(url(endpoint), body: payload.to_json, headers: @headers).parsed_response
      end
    end
  end
end
