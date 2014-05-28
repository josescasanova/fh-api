require 'oauth'

module Fancyhands
  module V1
    module Request
      class Requester
        class << self
          def get(endpoint, options = {})
            client.request(:get, endpoint, nil, {}, options)
            # nil, {} passed in thanks to oauth usage
          end

          def post(endpoint, body)
            client.request(:post, endpoint, nil, {}, body)
            # nil, {} passed in thanks to oauth usage
          end

          def client
            OAuth::Consumer.new(Fancyhands.key, Fancyhands.secret,
                                site: base_uri)
          end

          private
          def base_uri
            "https://www.fancyhands.com/api/v1"
          end
        end
      end
    end
  end
end
