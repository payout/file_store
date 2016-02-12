[![Gem Version](https://badge.fury.io/rb/file_store.svg)](https://badge.fury.io/rb/file_store) [![Build Status](https://travis-ci.org/payout/file_store.svg?branch=master)](https://travis-ci.org/payout/file_store) [![Code Climate](https://codeclimate.com/github/payout/file_store/badges/gpa.svg)](https://codeclimate.com/github/payout/file_store) [![Test Coverage](https://codeclimate.com/github/payout/file_store/badges/coverage.svg)](https://codeclimate.com/github/payout/file_store/coverage)

# FileStore

When working with microservices, managing file uploads isn't as straight forward as when working with a monolithic Rails app.  Instead, a file may need to get uploaded to one service and then made available to other services.  The FileStore gem makes it easy to upload a file in one service and then share a globally unique identifier for the file with other services.  Other services can then asynchronously download the file or provide a short-lived public URL for end customers to access it.

Currently FileStore only supports AWS S3, but other cloud storage options may be provided in the future.

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

### Uploading
```ruby
##
# Data can be sent either as a String or IO object
file_id = FileStore.upload(:app_attachment, 'file_name.txt', data)
  => "s3://bucket/app_attachment/NNN/NNN/NNN/NNN/file_name.txt"
```
FileStore automatically distributes files randomly within subdirectories and ensures that no one directory contains more than 1000 references to other files/directories. This improves file system performance for large sets of files.

The string value returned from the `::upload` method will be globally unique to your application and can be passed to other services as a file identifier.

### Downloading
```
url = FileStore.download_url(file_id, ttl: 60)
  => "https://temporary-public-download-url-from-amazon"
```
Currently, the only supported download method is to generate an expiring URL. This URL can be used anywhere to download the identified file for the specified amount of time, and can even be sent to end customers to access files.

### Testing
```ruby
##
# For testing, FileStore can be mocked. No requests will be made to AWS S3
FileStore.mock!
file_id = FileStore.upload(:app_attachment, 'file_name.txt', data)
url = FileStore.download_url(file_id, ttl: 60)
```
