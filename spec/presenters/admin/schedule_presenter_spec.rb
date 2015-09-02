describe Admin::SchedulePresenter do
  describe '#scheduled_massages' do
    let(:date) { '2015-09-02' }
    let!(:masseur) { create(:masseur) }

    subject(:scheduled_massages) do
      described_class.new(date).appointments
    end

    context 'when there are no massages scheduled for a given date' do
      it { is_expected.to_not be_empty }
      it { expect(scheduled_massages.count).to eq(30) }
    end

    context 'when there are massages scheduled for a given date' do
      let(:timetable) { Time.zone.parse('2015-09-02 9:00') }
      let(:massage) { Massage.first }
      let(:first_result) do
        [massage.timetable, massage.masseur.name, massage]
      end

      before do
        Timecop.travel(Time.zone.parse('2015-09-01 15:00')) do
          create(:massage, timetable: timetable, masseur: masseur)
        end
      end

      it { is_expected.to_not be_empty }
      it { expect(scheduled_massages.first).to match_array(first_result) }
      it { expect(scheduled_massages.count).to eq(30) }
    end
  end
end
