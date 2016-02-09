module FileStore
  module Providers
    autoload(:Provider, 'file_store/providers/provider')
    autoload(:S3,       'file_store/providers/s3')
  end # Providers
end # FileStore