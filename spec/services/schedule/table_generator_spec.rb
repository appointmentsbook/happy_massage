describe Schedule::TableGenerator do
  describe '#schedule_table' do
    subject(:schedule_table) { described_class.new.schedule_table }

    context 'when called' do
      it { is_expected.to_not be_nil }
      it { expect(schedule_table.count).to eq 30 }
    end
  end
end
