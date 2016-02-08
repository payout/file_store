# FileStore Gem

## Configuration

```ruby
FileStore.config do |c|
  c.aws_access_key = ''
  c.aws_access_secret = ''
  c.aws_s3_bucket = ''
end
```

## Usage

```ruby
file_id = FileStore.upload(data)
  => "bucket/NNN/NNN/NNN/NNN.dat"
  
file_id = FileStore.upload do
  file.read(1000) # Calls until nil is returned
end
  => "bucket/NNN/NNN/NNN/NNN/file_name.ext"

url = FileStore.download_url(file_id, ttl: 60)
  => "https://awspath"
```
