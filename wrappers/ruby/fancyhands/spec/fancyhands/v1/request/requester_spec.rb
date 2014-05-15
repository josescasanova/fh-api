require 'spec_helper'
require 'fancyhands/v1/request/requester'

module Fancyhands
  module V1
    module Request
      describe Requester do
        describe '.post' do
          it 'sends a :post to the oauth client with the given endpoint' do
            oauth_client = double(:oauth_client)
            Requester.stub(:client) { oauth_client }

            oauth_client.should_receive(:request).with(:post,
              '/request/something', nil, {}, { some: 'request_body' })
            Requester.post('/request/something', { some: 'request_body' })
          end

          end
        end
      end
    end
  end
end
