module FileStore
  class Instance
    def config
      (@__config ||= Config.new).tap { |config| yield config if block_given? }
    end

    def provider
      # Default to the S3 provider. This will be our only provider in the
      # forseeable future.
      @__provider ||= Providers::S3.new(config.to_h)
    end

    def method_missing(meth, *args, &block)
      if provider.respond_to?(meth)
        provider.public_send(meth, *args, &block)
      else
        super
      end
    end
  end # Instance
end # FileStore