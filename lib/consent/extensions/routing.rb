module Consent
  module Extensions
    module Routing
      
      def self.included(base)
        base.class_eval do
          def draw(&block)
            clear!
            MapperProxy.new(self.class.const_get(:Mapper).new(self)).instance_eval(&block)
            install_helpers
          end
        end
      end
      
      class MapperProxy
        include Expression::Generator
        
        attr_reader :map
        
        def initialize(mapper)
          @map = mapper
          
          %w(connect namespace).each do |method|
            @map.instance_eval <<-EOS
              def #{method}(*args, &block)
                args[1] = args[1].to_h if Consent::Expression === args[1]
                super(*args, &block)
              end
            EOS
          end
          
          def @map.root(*args, &block)
            args[0] = args.first.to_h if Consent::Expression === args.first
            super(*args, &block)
          end
        end
      end
      
    end
  end
end

