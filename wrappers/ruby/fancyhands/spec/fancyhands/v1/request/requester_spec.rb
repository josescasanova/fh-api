require 'spec_helper'
require 'fancyhands'
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

          it 'creates custom requests', :vcr do
            post = Requester.post('/request/custom',
                           { title: 'title',
                             description: 'desc',
                             bid: 1.0,
                             expiration_date: '2014-05-16T10:09:08Z' })

            post.msg.should == 'Created'
            post.code.should == '201'
          end
        end
      end
    end
  end
end
