describe StateMachines::User::Status do
  let(:user) { create(:user) }
  let(:state_machine) { described_class.new(user) }

  describe '#new' do
    subject(:status) { state_machine.aasm.current_state }

    it { is_expected.to eq :pending }
  end

  describe '#deactivate' do
    subject(:deactivate) { state_machine.deactivate }

    context 'when user is disabled' do
      context 'and user status was pending' do
        it { expect{ deactivate }.to change{user.reload.status}.from('pending').to('disabled') }
      end

      context 'and user status was enabled' do
        let(:user) { create(:user, status: 'enabled') }

        it { expect{ deactivate }.to change{user.reload.status}.from('enabled').to('disabled') }
      end
    end
  end

  describe '#activate' do
    subject(:activate) { state_machine.activate }

    context 'when user is enabled' do
      context 'and user status was pending' do
        let(:user) { create(:user) }

        it { expect { activate }.to change{ user.reload.status }.from('pending').to('enabled') }
      end

      context 'and user status was disabled' do
        let(:user) { create(:user, status: 'disabled') }

        it { expect { activate }.to change{ user.reload.status }.from('disabled').to('enabled') }
      end
    end
  end
end
