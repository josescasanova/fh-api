module Fancyhands
  module V1
    module Request
      class Custom
        attr_accessor :title, :description, :bid, :expiration_date

        def initialize(title, desc, bid, expiration_date, custom_fields = {})
          @title           = title
          @description     = desc
          @bid             = bid
          @expiration_date = expiration_date

          validate_required_fields
        end

        private
        def validate_required_fields
          raise TitleRequiredError          if title.strip.empty?
          raise DescriptionRequiredError    if description.strip.empty?
          raise BidRequiredError            if bid.nil?
          raise ExpirationDateRequiredError if expiration_date.strip.empty?
        end
      end
    end
  end
end
