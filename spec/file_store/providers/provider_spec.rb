module FileStore
  module Providers
    RSpec.describe Provider do
      let(:provider) { dummy_provider.new(opts) }
      let(:dummy_provider) do
        Class.new(Provider) do
          attr_accessor :hit_count

          def self.name
            'provider_name'
          end

          protected

          def required_configs; []; end
          def upload!(file_path, data); file_path; end
          def download_url!(file_id, opts); end

          def path_exists?(path)
            (@hit_count != 0).tap { @hit_count -= 1 }
          end
        end
      end
      let(:opts) { {} }

      describe '#upload' do
        subject { provider.upload('prefix', 'file_name.txt', 'data') }
        before { provider.hit_count = hit_count }

        context 'with an immediate unique path' do
          let(:hit_count) { 0 }
          it { is_expected.to match(/\Aprovider_name:\/\/prefix\/(\d{3}\/){4}file_name.txt\z/) }
        end

        context 'with a few path hits' do
          let(:hit_count) { 5 }
          it { is_expected.to match(/\Aprovider_name:\/\/prefix\/(\d{3}\/){4}file_name.txt\z/) }
        end

        context 'with path hit limit reached' do
          let(:hit_count) { 20 }
          it 'should raise an error' do
            expect { subject }.to raise_error 'could not find unique path'
          end
        end
      end # #upload

      describe '#download_url' do
        subject { provider.download_url(file_id) }

        let(:file_id) { 'provider_name://file-store-tests/some/file/id' }

        context 'with valid provider' do
          it 'should extract the provider' do
            expect(provider).to receive(:download_url!)
              .with('file-store-tests/some/file/id', opts)
            subject
          end
        end

        context 'with invalid provider' do
          let(:file_id) { 'invalid_provider_name://file-store-tests/some/file/id' }

          it 'should raise an error' do
            expect { subject }.to raise_error 'invalid provider: invalid_provider_name'
          end
        end
      end # #download_url

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

        it 'should create a file_id' do
          is_expected.to match(/\Amock:\/\/test\/(\d{3}\/){4}file_name.txt\z/)
        end
      end # #mock_upload

      describe '#mock_download_url' do
        subject { provider.mock_download_url(file_id) }
        let(:file_id) { 'mock://test/123/345/123/345/file_name.txt' }

        it 'should create a download url' do
          is_expected.to eq(
            "http://mocked_download_url.com/test/123/345/123/345/file_name.txt"
          )
        end
      end # #mock_download_url
    end # Provider
  end # Providers
end # FileStore
