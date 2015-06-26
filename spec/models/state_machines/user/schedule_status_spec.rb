describe StateMachines::User::ScheduleStatus do
  let(:user) { create(:user, schedule_status: schedule_status) }
  let(:state_machine) { described_class.new(user) }
  subject(:current_state) { state_machine.aasm.current_state }

  describe '#new' do
    let(:user) { create(:user) }

    it { is_expected.to eq :disabled }
  end

  describe '#enable_scheduling' do
    context 'when current_state is disabled' do
      let(:schedule_status) { 'disabled' }
      it do
        expect do
          state_machine.enable_scheduling
        end.to change { state_machine.aasm.current_state }
          .from(:disabled).to(:enabled)
      end
    end
  end

  describe '#penalize_absence' do
    context 'when current_state is enabled' do
      let(:schedule_status) { 'enabled' }

      it do
        expect do
          state_machine.penalize_absence
        end.to change { state_machine.aasm.current_state }
          .from(:enabled).to(:enabled_under_warning)
      end
    end

    context 'when current_state is enabled_under_warning' do
      let(:schedule_status) { 'enabled_under_warning' }

      it do
        expect do
          state_machine.penalize_absence
        end.to change { state_machine.aasm.current_state }
          .from(:enabled_under_warning).to(:forbidden_for_1_week)
      end
    end

    context 'when current_state is forbidden_for_1_week' do
      let(:schedule_status) { 'forbidden_for_1_week' }

      it do
        expect do
          state_machine.penalize_absence
        end.to change { state_machine.aasm.current_state }
          .from(:forbidden_for_1_week).to(:forbidden_for_1_month)
      end
    end
  end
end
