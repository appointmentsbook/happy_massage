describe Schedule::TableGenerator do
  describe '#schedule_table' do
    subject(:schedule_table) do
      described_class.new(massage_date).schedule_table
    end
    let(:massage_date) { Time.zone.today }

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
      it { is_expected.to_not include(Time.zone.parse('12:00')) }
      it { is_expected.to_not include(Time.zone.parse('12:15')) }
      it { is_expected.to_not include(Time.zone.parse('12:30')) }
      it { is_expected.to_not include(Time.zone.parse('12:45')) }
      it { is_expected.to_not include(Time.zone.parse('16:30')) }
    end
  end
end
