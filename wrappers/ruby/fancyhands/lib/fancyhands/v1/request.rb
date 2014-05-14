require 'fancyhands/v1/request/requester'
require 'fancyhands/v1/request/custom'

module Fancyhands
  module V1
    module Request
      class TitleRequiredError < StandardError; end
      class DescriptionRequiredError < StandardError; end
      class BidRequiredError < StandardError; end
      class ExpirationDateRequiredError < StandardError; end
    end
  end
end
