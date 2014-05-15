require 'oauth'

module Fancyhands
  module V1
    module Request
      class Requester
        class << self
          def post(endpoint, body)
            client.request(:post, endpoint, nil, {}, body)
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
