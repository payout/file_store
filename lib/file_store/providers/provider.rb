require 'securerandom'

module FileStore
  module Providers
    class Provider
      attr_reader :options

      def initialize(opts = {})
        required_configs.each { |c| fail "missing field: #{c}" unless opts[c] }

        @options = opts
        connect
      end

      def upload
        fail NotImplementedError
      end

      def download_url
        fail NotImplementedError
      end

      protected

      def connect
        fail NotImplementedError
      end

      def generate_unique_path(key)
        loop do
          path = key << 3.times.collect {
            '/%03d' %  SecureRandom.random_number(1000)
          }.join

          return path unless object_exists?(path)
        end
      end

      def object_exists?(path)
        fail NotImplementedError
      end

      def required_configs
        fail NotImplementedError
      end
    end # Provider
  end # Providers
end # FileStore