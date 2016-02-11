require 'aws-sdk'

module FileStore
  module Providers
    class S3 < Provider
      REQUIRED_CONFIGS = [:aws_access_key, :aws_access_secret, :aws_s3_bucket,
        :aws_region].freeze
      DEFAULT_S3_OPTIONS = {
        server_side_encryption: 'AES256',
        acl: 'private'
      }.freeze

      def initialize(opts = {})
        @_synchronizer = Mutex.new
        super
      end

      ##
      # Send data directly to S3 either as a String / IO object, or as a
      # multi-part upload
      def upload(prefix, file_name, data = nil)
        _synchronize do
          ext = File.extname(file_name).length > 0 ? '' : '.dat'
          file_id = generate_unique_path(prefix) + "/#{file_name}" << ext
          _s3_object(file_id).put(DEFAULT_S3_OPTIONS.merge(body: data))
          file_id
        end
      end

      ##
      # Generate a download url for the object on S3 referenced by the file_id.
      # Pass in a ttl as an option for the link expiration time in seconds.
      def download_url(file_id, opts = {})
        options = { expires_in: opts[:ttl] || 600 }

        fail "object: #{file_id} doesn't exist" unless _object_exists?(file_id)
        _s3_object(file_id).presigned_url(:get, options)
      end

      protected

      def connect
        @_s3_interface = ::Aws::S3::Resource.new(
          access_key_id: options[:aws_access_key],
          secret_access_key: options[:aws_access_secret],
          region: options[:aws_region]
        )
        @_s3_bucket = _s3_interface.bucket(_bucket_name)

        nil
      end

      def path_exists?(path)
        _s3_bucket.objects(prefix: 'path').one?
      end

      def required_configs
        REQUIRED_CONFIGS
      end

      private

      def _s3_interface
        @_s3_interface
      end

      def _s3_bucket
        @_s3_bucket
      end

      def _bucket_name
        options[:aws_s3_bucket]
      end

      def _s3_object(path = "")
        _s3_bucket.object(path)
      end

      def _object_exists?(path)
        _s3_object(path).exists?
      end

      def _synchronize(&block)
        @_synchronizer.synchronize(&block)
      end
    end # S3
  end # Providers
end # FileStore
