require 'open-uri'

module FileStore
  module Providers
    RSpec.describe S3 do
      let(:provider) { S3.new(opts) }
      let(:opts) { {} }
      let(:s3_test_opts) do
        {
          aws_access_key: ENV['AWS_ACCESS_KEY'],
          aws_access_secret: ENV['AWS_ACCESS_SECRET'],
          aws_s3_bucket: 'file-store-tests',
          aws_region: 'us-east-1'
        }
      end

      describe '#initialize' do
        subject { provider }

        context 'with missing config values' do
          context 'without aws_access_key' do

            let(:opts) do
              {
                aws_access_secret: 'secret',
                aws_s3_bucket: 'bucket',
                aws_region: 'us-east-1'
              }
            end

            it 'should raise an error' do
               expect { subject}.to raise_error 'missing fields: aws_access_key'
            end
          end # without aws_access_key

          context 'without aws_access_secret' do
            let(:opts) do
              {
                aws_access_key: 'abc123',
                aws_s3_bucket: 'bucket',
                aws_region: 'us-east-1'
              }
            end

            it 'should raise an error' do
               expect { subject}.to raise_error 'missing fields: aws_access_secret'
            end
          end # without aws_access_secret

          context 'without aws_s3_bucket' do
            let(:opts) do
              {
                aws_access_key: 'abc123',
                aws_access_secret: 'secret',
                aws_region: 'us-east-1'
              }
            end

            it 'should raise an error' do
               expect { subject}.to raise_error 'missing fields: aws_s3_bucket'
            end
          end # without aws_s3_bucket

          context 'without aws_region' do
            let(:opts) do
              {
                aws_access_key: 'abc123',
                aws_access_secret: 'secret',
                aws_s3_bucket: 'bucket'
              }
            end

            it 'should raise an error' do
               expect { subject}.to raise_error 'missing fields: aws_region'
            end
          end # without aws_region

          context 'with multiple missing configs' do
            let(:opts) do
              {
                aws_access_secret: 'secret',
                aws_s3_bucket: 'bucket'
              }
            end

            it 'should raise an error' do
               expect { subject}.to raise_error 'missing fields: aws_access_key, aws_region'
            end
          end # with multiple missing configs
        end # with missing config values

        context 'with config values' do
          let(:opts) { s3_test_opts }
          it { is_expected.to be_a S3 }
        end
      end # #initialize

      describe '#upload' do
        subject { provider.upload(prefix, file_name, data) }
        let(:opts) { s3_test_opts }
        let(:prefix) { 'test-files' }
        let(:path) { 'spec/dummy/data.txt' }

        context 'with string upload' do
          let(:file_name) { 'data.txt' }
          let(:data) { File.open(path).read }

          it { is_expected.to match(/\As3:\/\/file-store-tests\/test-files\/(\d{3}\/){4}data.txt\z/) }

          context 'without filename extension' do
            let(:file_name) { 'data' }
            it { is_expected.to match(/\As3:\/\/file-store-tests\/test-files\/(\d{3}\/){4}data.dat\z/) }
          end
        end # with string upload

        context 'with file upload' do
          let(:file_name) { 'data.txt' }
          let(:data) { File.open(path) }

          it { is_expected.to match(/\As3:\/\/file-store-tests\/test-files\/(\d{3}\/){4}data.txt\z/) }

          context 'without filename extension' do
            let(:file_name) { 'data' }
            it { is_expected.to match(/\As3:\/\/file-store-tests\/test-files\/(\d{3}\/){4}data.dat\z/) }
          end
        end # with file upload
      end # #upload

      describe '#download_url' do
        subject { download_url }

        let(:download_url) { provider.download_url(file_id, download_opts) }
        let(:file_id) do
          provider.upload('test-files', 'data.txt', File.open(path))
        end
        let(:path) { 'spec/dummy/data.txt' }
        let(:download_opts) { {} }
        let(:opts) { s3_test_opts }
        let(:s3_file) { open(subject).read }
        let(:s3_file_hash) { Digest::SHA256.hexdigest(s3_file) }
        let(:orig_file_hash) { Digest::SHA256.file(path).hexdigest }

        context 'with object existing' do
          it 'should download the same file that was uploaded' do
            expect(s3_file_hash).to eq orig_file_hash
          end

          context 'with ttl=1' do
            let(:download_opts) { {ttl: 1} }

            it 'should expire the download link after the ttl' do
              download_url # prime the download_url
              sleep(1.1)
              expect {
                s3_file
              }.to raise_error OpenURI::HTTPError, '403 Forbidden'
            end
          end
        end # with object existing

        context 'with invalid provider' do
          let(:file_id) { 'rackspace://a-different-bucket/some/file/id' }

          it 'should raise an error' do
            expect { subject }.to raise_error "invalid provider: rackspace"
          end
        end

        context 'with invalid bucket' do
          let(:file_id) { 's3://a-different-bucket/some/file/id' }

          it 'should raise an error' do
            expect { subject }.to raise_error "invalid bucket: a-different-bucket"
          end
        end

        context 'with object not existing' do
          let(:file_id) { 's3://file-store-tests/some/bad/file/id' }

          it 'should raise an error' do
            expect { subject }.to raise_error "object: some/bad/file/id doesn't exist"
          end
        end
      end # #download_url
    end # S3
  end # Providers
end # FileStore
