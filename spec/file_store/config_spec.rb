module FileStore
  RSpec.describe Config do
    let(:config) { Config.new }

    it 'should have a list of valid configs' do
      expect(Config::VALID_CONFIGS).to eq [:aws_access_key, :aws_access_secret,
        :aws_s3_bucket, :aws_region]
    end

    describe 'config setters' do
      subject { config.send("#{field}=", 'test') }

      context 'with valid config option' do
        let(:field) { :aws_access_key }

        it 'should set the config value' do
          subject
          expect(config.to_h).to eq(field => 'test')
        end
      end

      context 'with invalid config option' do
        let(:field) { :invalid_config_option }

        it 'should get a method_missing error' do
          expect { subject }.to raise_error NoMethodError
        end
      end
    end # config setters

    describe 'config getters' do
      subject { config.send(field) }

      context 'with valid config option' do
        let(:field) { :aws_access_key }

        context 'with config set' do
          before { config.send("#{field}=", 'test') }

          it { is_expected.to eq 'test' }
        end

        context 'with config not set' do
          it { is_expected.to eq nil }
        end
      end

      context 'with invalid config option' do
        let(:field) { :invalid_config_option }

        it 'should get a method_missing error' do
          expect { subject }.to raise_error NoMethodError
        end
      end
    end # config getters

    describe '#to_h' do
      subject { config.to_h }

      context 'with config values' do
        before {
          config.aws_access_key = "abc123"
          config.aws_access_secret = "secret"
        }

        it 'should return a hash of the config values' do
          is_expected.to eq(aws_access_key: 'abc123', aws_access_secret: 'secret')
        end
      end # with config values

      context 'without config values' do
        it { is_expected.to eq({}) }
      end
    end # #to_h
  end # Config
end # FileStore