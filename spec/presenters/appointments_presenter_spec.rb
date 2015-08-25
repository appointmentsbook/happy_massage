describe AppointmentsPresenter do
  let(:user) { create(:user) }

  before do
    allow_any_instance_of(Massage).to receive(:valid?).and_return(true)
  end

  describe '#next_appointments' do
    subject(:next_appointments) { described_class.new(user).next_appointments }

    context 'when there are appointments with scheduled status' do
      let!(:scheduled_massage) { create(:massage, user: user) }

      it { is_expected.to match_array([scheduled_massage]) }
    end

    context 'when there are no appointments with scheduled status' do
      it { is_expected.to match_array([]) }
    end
  end

  describe '#past_appointments' do
    subject(:past_appointments) { described_class.new(user).past_appointments }

    context 'when there was an appointments in the past' do
      let!(:attended_massage) { create(:massage, :attended, user: user) }

      it { is_expected.to match_array([attended_massage]) }
    end

    context 'when there are no past appointments' do
      it { is_expected.to match_array([]) }
    end
  end
end
