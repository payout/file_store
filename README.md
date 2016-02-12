[![Gem Version](https://badge.fury.io/rb/file_store.svg)](https://badge.fury.io/rb/file_store) [![Build Status](https://travis-ci.org/payout/file_store.svg?branch=master)](https://travis-ci.org/payout/file_store) [![Code Climate](https://codeclimate.com/github/payout/file_store/badges/gpa.svg)](https://codeclimate.com/github/payout/file_store) [![Test Coverage](https://codeclimate.com/github/payout/file_store/badges/coverage.svg)](https://codeclimate.com/github/payout/file_store/coverage)

# FileStore Gem

## Configuration

Ensure that you have created an AWS S3 bucket with the proper permissions.

```ruby
FileStore.config do |c|
  c.aws_access_key = ''
  c.aws_access_secret = ''
  c.aws_s3_bucket = ''
  c.aws_region = ''
end
```

## Usage

```ruby
##
# Data can be sent either as a String or IO object
file_id = FileStore.upload(:app_attachment, 'file_name.txt', data)
  => "s3://bucket/app_attachment/NNN/NNN/NNN/NNN/file_name.txt"

url = FileStore.download_url(file_id, ttl: 60)
  => "https://awspath"

##
# For testing, FileStore can be mocked. No requests will be made to AWS S3
FileStore.mock!
file_id = FileStore.upload(:app_attachment, 'file_name.txt', data)
url = FileStore.download_url(file_id, ttl: 60)
```

