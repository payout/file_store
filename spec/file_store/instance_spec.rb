module FileStore
  RSpec.describe Instance do
    let(:instance) { Instance.new }

    describe '#config' do
      subject { instance.config(&block) }

      let(:block) do
        proc { |config| config.aws_access_key = 'abc123' }
      end

      it { is_expected.to be_a FileStore::Config }

      it 'should set up the config object' do
        expect(subject.to_h).to eq(aws_access_key: 'abc123')
      end
    end # #config

    describe '#provider' do
      subject { instance.provider }
      before {
        instance.config { |c|
          c.aws_access_key = 'abc123'
          c.aws_access_secret = 'secret'
          c.aws_s3_bucket = 'bucket'
          c.aws_region = 'us-east-1'
        }
      }

      it { is_expected.to be_a Providers::S3 }
    end # #provider

    describe '#method_missing' do
      subject { instance.upload('', '', '') }

      let(:provider) { instance.provider }

      before {
        instance.config { |c|
          c.aws_access_key = 'abc123'
          c.aws_access_secret = 'secret'
          c.aws_s3_bucket = 'bucket'
          c.aws_region = 'us-east-1'
        }
      }

      it 'should send the method to the provider' do
        expect(provider).to receive(:upload).with('', '', '').once
        subject
      end

      context 'with mocked file-store' do
        before { instance.mock! }

        it 'should send the mocked method to the provider' do
          expect(provider).to receive(:mock_upload).with('', '', '').once
          subject
        end
      end # with mocked file-store
    end # #method_missing
  end # Instance
end # FileStore