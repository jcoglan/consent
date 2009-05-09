module Consent
  module Extensions
    module UrlHelper
      
      include Expression::Generator
      
      def url_for(*args)
        args[0] = args.first.to_h if Expression === args.first
        super(*args)
      end
      
    end
  end
end

