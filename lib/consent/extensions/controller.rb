module Consent
  module Extensions
    module Controller
      
      include Expression::Generator
      
      def redirect_to(*args)
        args[0] = args.first.to_h if Expression === args.first
        super(*args)
      end
      
    end
  end
end

