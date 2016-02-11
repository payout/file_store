require 'securerandom'

module FileStore
  module Providers
    class Provider
      attr_reader :options

      def initialize(opts = {})
        if (missing_fields = required_configs - opts.keys).length > 0
          fail "missing fields: #{missing_fields.join(', ')}"
        end

        @mock = false
        @options = opts
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
        ext = Utils.generate_ext_if_needed(file_name)
        prefix + _generate_random_path << "/#{file_name}" << ext
      end

      def mock_download_url(file_id, opts = {})
        "http://mocked_download_url.com/#{file_id}"
      end

      protected

      def generate_unique_path(prefix)
        20.times do
          path = prefix + _generate_random_path
          return path unless path_exists?(path)
        end

        fail "could not find unique path"
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
        4.times.map { '/%03d' %  SecureRandom.random_number(1000) }.join
      end
    end # Provider
  end # Providers
end # FileStore