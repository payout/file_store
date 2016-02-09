$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "file_store/version"

Gem::Specification.new do |s|
  s.name        = 'file_store'
  s.version     = FileStore::VERSION
  s.homepage    = "http://github.com/payout/file_store"
  s.license     = 'MIT'
  s.summary     = ""
  s.description = s.summary
  s.authors     = ["Robert Honer", "Kayvon Ghaffari"]
  s.email       = ['robert@payout.com', 'kayvon@payout.com']
  s.files       = Dir['lib/**/*.rb']

  s.add_dependency 'aws-sdk', '~> 2.2.14'
  s.add_development_dependency 'rspec'
end
