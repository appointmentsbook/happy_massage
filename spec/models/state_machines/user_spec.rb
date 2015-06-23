describe StateMachines::User do
  let(:user) { create(:user) }
  subject { described_class.new(user).status }

  describe '#new', focus: true do
    it { is_expected.to eq :pending }
  end
end