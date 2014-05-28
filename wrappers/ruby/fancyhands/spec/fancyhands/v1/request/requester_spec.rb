require 'spec_helper'
require 'fancyhands'
require 'fancyhands/v1/request/requester'

module Fancyhands
  module V1
    module Request
      describe Requester do
        def assert_oauth_client_received(method, url, options)
          oauth_client = double(:oauth_client)
          Requester.stub(:client) { oauth_client }

          oauth_client.should_receive(:request)
                      .with(method, url, nil, {}, options)
                      # nil, {} passed in thanks to oauth usage
        end

        describe '.get' do
          it 'sends a :get to the oauth client with the given endpoint' do
            assert_oauth_client_received(:get, '/request/something',
                                         { some: 'request_body' })
            Requester.get('/request/something', { some: 'request_body' })
          end

          it 'gets custom requests', :vcr do
            response = Requester.get('/request/custom')
            response.msg.should == 'OK'
            response.code.should == '200'
          end
        end

        describe '.post' do
          it 'sends a :post to the oauth client with the given endpoint' do
            assert_oauth_client_received(:post, '/request/something',
                                         { some: 'request_body' })
            Requester.post('/request/something', { some: 'request_body' })
          end

          it 'creates custom requests', :vcr do
            response = Requester.post('/request/custom',
                           { title: 'title',
                             description: 'desc',
                             bid: 1.0,
                             expiration_date: '2014-05-16T10:09:08Z' })

            response.msg.should == 'Created'
            response.code.should == '201'
          end
        end
      end
    end
  end
end
