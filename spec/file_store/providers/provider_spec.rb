module FileStore
  module Providers
    RSpec.describe Provider do
      let(:provider) { dummy_provider.new(opts) }
      let(:dummy_provider) do
        Class.new(Provider) {
          protected
          def connect; end

          def required_configs
            []
          end
        }
      end
      let(:opts) { {} }

      describe '#mock!' do
        subject { provider.mock! }

        it 'should set mocked to true' do
          expect(provider.mocked?).to eq false
          subject
          expect(provider.mocked?).to eq true
        end
      end # #mock!

      describe '#mock_upload' do
        subject { provider.mock_upload(prefix, file_name, data) }
        let(:prefix) { 'test' }
        let(:file_name) { 'file_name.txt' }
        let(:data) { 'dummydata' }

        it { is_expected.to match(/\Atest\/(\d{3}\/){4}file_name.txt\z/) }
      end # #mock_upload

      describe '#mock_download_url' do
        subject { provider.mock_download_url(file_id) }
        let(:file_id) { 'test/123/345/123/345/file_name.txt' }

        it { is_expected.to eq("http://mocked_download_url.com/#{file_id}") }
      end # #mock_download_url
    end # Provider
  end # Providers
end # FileStore
