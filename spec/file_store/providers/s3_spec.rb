module FileStore
  module Providers
    RSpec.describe S3 do
      let(:provider) { S3.new(opts) }
      let(:opts) { {} }

      describe '#initialize' do
        subject { provider }

        context 'with missing config values' do
          context 'without aws_access_key' do

            let(:opts) {
              {
                aws_access_secret: 'secret',
                aws_s3_bucket: 'bucket',
                aws_region: 'us-east-1'
              }
            }

            it 'should raise an error' do
               expect { subject}.to raise_error 'missing field: aws_access_key'
            end
          end

          context 'without aws_access_secret' do
            let(:opts) {
              {
                aws_access_key: 'abc123',
                aws_s3_bucket: 'bucket',
                aws_region: 'us-east-1'
              }
            }

            it 'should raise an error' do
               expect { subject}.to raise_error 'missing field: aws_access_secret'
            end
          end

          context 'without aws_s3_bucket' do
            let(:opts) {
              {
                aws_access_key: 'abc123',
                aws_access_secret: 'secret',
                aws_region: 'us-east-1'
              }
            }

            it 'should raise an error' do
               expect { subject}.to raise_error 'missing field: aws_s3_bucket'
            end
          end

          context 'without aws_region' do
            let(:opts) {
              {
                aws_access_key: 'abc123',
                aws_access_secret: 'secret',
                aws_s3_bucket: 'bucket'
              }
            }

            it 'should raise an error' do
               expect { subject}.to raise_error 'missing field: aws_region'
            end
          end
        end

        context 'with config values' do
          let(:opts) {
            {
              aws_access_key: 'abc123' || ENV['AWS_ACCESS_KEY'],
              aws_access_secret: 'secret' || ENV['AWS_ACCESS_SECRET'],
              aws_s3_bucket: 'bucket' || ENV['AWS_S3_BUCKET'],
              aws_region: 'us-east-1' || ENV['AWS_REGION']
            }
          }

          it { is_expected.to be_a S3 }
        end
      end # #initialize

      describe '#upload' do
        subject { provider.upload(key, file_name, data) }

      end # #upload

      describe '#download_url' do
        subject { provider.download_url(file_id, download_opts) }
      end # #download_url
    end # S3
  end # Providers
end # FileStore
