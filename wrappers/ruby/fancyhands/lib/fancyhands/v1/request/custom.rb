module Fancyhands
  module V1
    module Request
      class Custom
        module RequesterMethods; def requester; Requester; end; end
        include RequesterMethods; extend RequesterMethods

        STATUSES = { new: 1, open: 5, closed: 20, expired: 21 }

        attr_accessor :title, :description, :bid, :expiration_date,
          :custom_fields

        def initialize(title, desc, bid, expiration_date, custom_fields = {})
          @title           = title
          @description     = desc
          @bid             = bid
          @expiration_date = expiration_date
          @custom_fields   = custom_fields

          validate_required_fields
        end

        def create
          requester.post('/request/custom',
                         { title: title,
                           description: description,
                           bid: bid,
                           expiration_date: expiration_date,
                           custom_fields: custom_fields })
        end

        def self.all(options = {})
          options = build_options_for_all(options)
          requester.get('/request/custom', options)
        end

        def self.find(key)
          requester.get('/request/custom', key: key)
        end

        private
        def validate_required_fields
          raise TitleRequiredError          if title.strip.empty?
          raise DescriptionRequiredError    if description.strip.empty?
          raise BidRequiredError            if bid.nil?
          raise ExpirationDateRequiredError if expiration_date.strip.empty?
        end

        def self.build_options_for_all(options)
          status = options[:status]
          page   = options.delete(:page)
          options[:status] = STATUSES[status] if status
          options[:cursor] = page if page
          options
        end
      end

      class TitleRequiredError < StandardError; end
      class DescriptionRequiredError < StandardError; end
      class BidRequiredError < StandardError; end
      class ExpirationDateRequiredError < StandardError; end
    end
  end
end
