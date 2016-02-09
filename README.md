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
file_id = FileStore.upload(data, :app_attachment)
  => "bucket/app_attachment/NNN/NNN/NNN/NNN/file_name.ext"

file_id = FileStore.upload do
  file.read(1000) # Calls until nil is returned
end
  => "bucket/app_attachment/NNN/NNN/NNN/NNN/file_name.ext"

url = FileStore.download_url(file_id, ttl: 60)
  => "https://awspath"
```
