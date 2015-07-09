describe Schedule::TableGenerator do
  describe '#schedule_table' do
    subject(:schedule_table) do
      described_class.new(args).schedule_table
    end
    let(:massage_date) { Time.zone.today }
    let(:args) { { massage_date: massage_date } }

    context 'when table is generated' do
      it { is_expected.to_not be_nil }
      it { expect(schedule_table.count).to eq 30 }
    end

    context 'when a timetable corresponds to a massage' do
      it { is_expected.to include(Time.zone.parse('09:00')) }
      it { is_expected.to include(Time.zone.parse('10:45')) }
      it { is_expected.to include(Time.zone.parse('14:30')) }
      it { is_expected.to include(Time.zone.parse('17:45')) }
    end

    context 'when a timetable corresponds to a pause' do
      it { is_expected.to_not include(Time.zone.parse('10:30')) }
      it { is_expected.to_not include(Time.zone.parse('13:15')) }
      it { is_expected.to_not include(Time.zone.parse('13:30')) }
      it { is_expected.to_not include(Time.zone.parse('14:00')) }
      it { is_expected.to_not include(Time.zone.parse('14:15')) }
    end
  end
end
