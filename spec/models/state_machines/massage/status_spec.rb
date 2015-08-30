describe StateMachines::Massage::Status do
  let(:time) { '2015-08-18 15:00' }
  let(:timetable) { '2015-08-19 9:00' }
  let(:massage) { create(:massage, timetable: timetable) }

  before { Timecop.freeze(time) }

  after { Timecop.return }

  describe '#new' do
    context 'when massage was not created yet' do
      let(:massage) { build(:massage, timetable: timetable) }

      it { expect(massage.aasm.current_state).to eq :pending }
    end
  end

  describe '#schedule!' do
    context 'when current state corresponds to "pending"' do
      let(:massage) { build(:massage, timetable: timetable) }

      it 'sets status as "scheduled"' do
        expect { massage.schedule! }
          .to change { massage.aasm.current_state }
          .from(:pending).to(:scheduled)
      end
    end
  end

  describe '#mark_presence!' do
    context 'when current status corresponds to "scheduled"' do
      it 'sets status as "attended"' do
        expect { massage.mark_presence! }
          .to change { massage.aasm.current_state }
          .from(:scheduled).to(:attended)
      end
    end
  end

  describe '#mark_absence!' do
    context 'when current status corresponds to "scheduled"' do
      before { massage.update_attributes!(status: 'scheduled') }

      it 'sets status as "missed"' do
        expect { massage.mark_absence! }
          .to change { massage.aasm.current_state }
          .from(:scheduled).to(:missed)
      end
    end
  end
end
