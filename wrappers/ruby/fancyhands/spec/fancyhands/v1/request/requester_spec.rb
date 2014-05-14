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
              'https://www.fancyhands.com/api/v1/request/something',
              'arg1', 'arg2', 3.2, {})
            Requester.post('/request/something', 'arg1', 'arg2', 3.2, {})
          end
        end
      end
    end
  end
end
