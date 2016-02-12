module FileStore
  class Config
    VALID_CONFIGS = [:aws_access_key, :aws_access_secret, :aws_s3_bucket,
      :aws_region].freeze

    def initialize
      @_config_hash = {}
    end

    ##
    # Set up accessors for the config fields
    VALID_CONFIGS.each { |config|
      define_method(config) { @_config_hash[config] }
      define_method("#{config}=") { |value| @_config_hash[config] = value }
    }

    def to_h
      @_config_hash
    end
  end # Config
end # FileStore
