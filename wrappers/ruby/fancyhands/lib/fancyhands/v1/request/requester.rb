module Fancyhands
  module V1
    module Request
      class Requester
        class << self
          def post(endpoint, *args)
            client.request(:post, url(endpoint), *args)
          end

          private
          def url(endpoint)
            "https://www.fancyhands.com/api/v1#{endpoint}"
          end
        end
      end
    end
  end
end
