describe AppointmentsPresenter do
  let(:user) { create(:user) }

  before do
    allow_any_instance_of(Massage).to receive(:valid?).and_return(true)
  end

  describe '#recent_appointments' do
    let!(:scheduled_massage) do
      create(
        :massage,
        user: user,
        location: 'lala',
        timetable: Time.zone.parse('2015-10-11 9:00')
      )
    end

    subject(:recent_appointments) do
      described_class.new(user).recent_appointments
    end

    context 'when timetable belongs to recent interval' do
      before { Timecop.travel(scheduled_massage.timetable) }

      after { Timecop.return }

      it { is_expected.to match_array([scheduled_massage]) }
    end

    context 'when timetable does not belong to recent interval' do
      before do
        Timecop.travel(
          scheduled_massage.timetable + ScheduleSettings.massage_duration
        )
      end

      after { Timecop.return }

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
