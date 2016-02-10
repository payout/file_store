RSpec.describe FileStore do
  describe '::instance' do
    subject { FileStore.instance }

    it { is_expected.to be_a FileStore::Instance }
  end # ::instance
end # FileStore
