require 'file_store/version'

module FileStore
  autoload(:Config,    'file_store/config')
  autoload(:Instance,  'file_store/instance')
  autoload(:Providers, 'file_store/providers')
  autoload(:Utils,     'file_store/utils')

  class << self
    def method_missing(meth, *args, &block)
      instance.public_send(meth, *args, &block)
    end

    def instance
      @__instance ||= Instance.new
    end
  end # Class Methods
end # FileStore
