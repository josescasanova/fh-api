require 'spec_helper'
require 'fancyhands/v1/request/requester'
require 'fancyhands/v1/request/custom'

module Fancyhands
  module V1
    module Request
      describe Custom do
        def build_request(title, desc, bid, exp_date, custom_fields = {})
          Custom.new(title, desc, bid, exp_date, custom_fields)
        end

        describe '#initialize' do
          it 'requires the APIs required fields' do
            expect { build_request('', '', nil, '') }
              .to raise_error(TitleRequiredError)

            expect { build_request('title', '', nil, '') }
              .to raise_error(DescriptionRequiredError)

            expect { build_request('title', 'desc', nil, '') }
              .to raise_error(BidRequiredError)

            expect { build_request('title', 'desc', 1, '') }
              .to raise_error(ExpirationDateRequiredError)
          end

          it 'sets the attr accessors with the fields' do
            request = build_request('title', 'desc', 1.0, '2014-05-15T10:09:08Z')

            request.title.should == 'title'
            request.description.should == 'desc'
            request.bid.should == 1.0
            request.expiration_date.should == '2014-05-15T10:09:08Z'
          end
        end

        describe '#create' do
          let(:custom_request) do
            build_request('title', 'desc', 1.0, '2014-05-15T10:09:08Z', {})
          end

          it "posts the fields and the fancyhands endpoint to the requester" do
            Requester.should_receive(:post).with('/request/custom',
                                     { title: 'title',
                                       description: 'desc',
                                       bid: 1.0,
                                       expiration_date: '2014-05-15T10:09:08Z',
                                       custom_fields: {} })
            custom_request.create
          end
        end

        describe '.all' do
          it 'gets all requests at first page' do
            Requester.should_receive(:get).with('/request/custom', {})
            Custom.all
          end

          { new: 1, open: 5, closed: 20, expired: 21 }.each do |status, code|
            context "with #{status} status_code option" do
              it "gets all requests at first page for #{status}" do
                Requester.should_receive(:get).with('/request/custom',
                                                    { status: code })
                Custom.all({ status: status })
              end
            end
          end

          context 'with cursor option' do
            it 'gets all requests at the given cursor position' do
              Requester.should_receive(:get).with('/request/custom',
                                                  { cursor: 3 })
              Custom.all({ page: 3 })
            end
          end
        end

        describe '.find' do
          it 'gets the request by key' do
            Requester.should_receive(:get).with('/request/custom', { key: 3 })
            Custom.find(3)
          end
        end
      end
    end
  end
end
