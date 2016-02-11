require 'securerandom'

module FileStore
  module Providers
    class Provider
      attr_reader :options

      def initialize(opts = {})
        required_configs.each { |c| fail "missing field: #{c}" unless opts[c] }

        @mock = false
        @options = opts
        connect
      end

      def upload(prefix, file_name, data = nil)
        fail NotImplementedError
      end

      def download_url(file_id, opts = {})
        fail NotImplementedError
      end

      def mock!
        @mock = true
      end

      def mocked?
        !!@mock
      end

      def mock_upload(prefix, file_name, data = nil)
        ext = File.extname(file_name).length > 0 ? '' : '.dat'
        prefix << _generate_random_path << "/#{file_name}" << ext
      end

      def mock_download_url(file_id, opts = {})
        "http://downloadurl.com/#{file_id}"
      end

      protected

      def connect
        fail NotImplementedError
      end

      def generate_unique_path(prefix)
        loop do
          path = prefix << _generate_random_path
          return path unless path_exists?(path)
        end
      end

      def path_exists?(path)
        fail NotImplementedError
      end

      def required_configs
        fail NotImplementedError
      end

      private

      ##
      # Will create a random path of four 3-digit numbers i.e. /123/456/789/321
      def _generate_random_path
        4.times.collect { '/%03d' %  SecureRandom.random_number(1000) }.join
      end
    end # Provider
  end # Providers
end # FileStore