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
data =
file_id = FileStore.upload(:app_attachment, 'file_name.txt', data)
  => "bucket/app_attachment/NNN/NNN/NNN/NNN/file_name.txt"

url = FileStore.download_url(file_id, ttl: 60)
  => "https://awspath"

##
# For testing, FileStore can be mocked. No requests will be made to AWS S3
FileStore.mock!
file_id = FileStore.upload(:app_attachment, 'file_name.txt', data)
url = FileStore.download_url(file_id, ttl: 60)
```

