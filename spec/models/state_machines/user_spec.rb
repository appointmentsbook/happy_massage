describe StateMachines::User do
  let(:user) { create(:user) }
  let(:state_machine) { described_class.new(user) }
  subject { state_machine.status }

  describe '#new' do
    it { is_expected.to eq 'pending' }
  end

  describe '#deactivate' do
    context 'when account is "disabled"' do
      before { state_machine.deactivate }

      it { is_expected.to eq 'disabled' }
    end
  end
end