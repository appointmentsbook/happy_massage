describe StateMachines::Massage::Status do
  let(:massage) { create(:massage) }
  let(:state_machine) { described_class.new(massage) }
  subject(:current_state) { state_machine.current_state }

  describe '#new' do
    it { is_expected.to eq 'pending' }
  end

  describe '#schedule_has_been_scheduled!' do
    before { state_machine.massage_has_been_scheduled! }

    it { is_expected.to eq 'scheduled' }
  end

  describe '#massage_has_been_attended!' do
    before { state_machine.massage_has_been_attended! }

    it { is_expected.to eq 'attended' }
  end

  describe '#massage_has_been_cancelled!' do
    before { state_machine.massage_has_been_cancelled! }

    it { is_expected.to eq 'cancelled' }
  end

  describe '#massage_has_been_missed!' do
    before { state_machine.massage_has_been_missed! }

    it { is_expected.to eq 'missed' }
  end
end
