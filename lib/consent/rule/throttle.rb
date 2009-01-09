require 'yaml'
require 'fileutils'

module Consent
  class Rule
    class Throttle
      
      HISTORY_FILE = "#{ RAILS_ROOT }/tmp/consent/#{ RAILS_ENV }.yml"
      
      attr_reader :id, :key, :times
      @@data = {}
      
      def initialize(id, key, rate = nil)
        @id, @key, @rate, @times = id, key, rate, []
        @@instances ||= []
        @@instances << self
        
        if data = ( ( @@data || {} )[id] || {} )[key]
          @times = data.map do |time|
            parts = time.split(/\D+/).map { |n| n.to_i }
            Time.gm(*parts)
          end
        end
      end
      
      def rate=(rate)
        rate = Rate.new(1, rate) if Numeric === rate
        @rate = rate
      end
      
      def ping!
        @times << Time.now
      end
      
      def over_capacity?
        flush!
        @times.size >= @rate.limit
      end
      
      def flush!
        cutoff = @rate.interval.ago
        @times.delete_if { |time| time < cutoff }
      end
      
      def self.to_yaml
        (@@instances || []).inject({}) { |hash, throttle|
          table = (hash[throttle.id] ||= {})
          table[throttle.key] = throttle.times.map do |time|
            time.strftime('%Y-%m-%d %H:%M:%S')
          end
          hash
        }.to_yaml
      end
      
      def self.dump
        FileUtils.mkdir_p(File.dirname(HISTORY_FILE))
        File.open(HISTORY_FILE, 'wb') { |file| file.write(Throttle.to_yaml) }
      end
      
      Kernel.at_exit(&method(:dump))
      @@data = YAML.load(File.read(HISTORY_FILE)) if File.file?(HISTORY_FILE)
      
    end
  end
end

