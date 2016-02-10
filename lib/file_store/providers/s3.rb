require 'aws-sdk'

module FileStore
  module Providers
    class S3 < Provider
      REQUIRED_CONFIGS = [:aws_access_key, :aws_access_secret, :aws_s3_bucket,
        :aws_region].freeze

      def initialize(opts = {})
        @_synchronizer = Mutex.new
        super
      end

      ##
      # Send data directly to S3 either as a String / IO object, or as a
      # multi-part upload
      def upload(key, file_name, data)
        _synchronize do
          file_id = generate_unique_path(key) + "/#{file_name}.dat"

          if block_given?
            loop do
              break unless data
              _s3_object.multi_part_upload(data)
              data = yield
            end
          else
            _s3_object(file_id).put(
              body: data,
              server_side_encryption: 'AES256',
              acl: 'private'
            )
          end

          file_id
        end
      end

      ##
      # Generate a download url for the object on S3 referenced by the file_id.
      # Pass in a ttl as an option for the link expiration time in seconds.
      def download_url(file_id, opts = {})
        options = { expires_in: opts[:ttl] || 600 }
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

      def object_exists?(path)
        _s3_object(path).exists?
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

      def _synchronize(&block)
        @_synchronizer.synchronize(&block)
      end
    end # S3
  end # Providers
end # FileStore
