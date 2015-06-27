describe User do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
  end

  describe '#new' do
    subject(:status) { described_class.new.status }

    it { is_expected.to eq 'pending'}
  end
end
