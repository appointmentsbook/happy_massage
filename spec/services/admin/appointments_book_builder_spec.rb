describe Admin::AppointmentsBookBuilder do
  describe '#appointments' do
    subject(:appointments) { described_class.new(date).appointments }

    context 'when there are 3 enabled masseurs' do
      let(:date) { Time.zone.parse('2015-09-14 9:00').to_date }
      let!(:masseur1) { create(:masseur) }
      let!(:masseur2) { create(:masseur) }
      let!(:masseur3) { create(:masseur) }

      context 'and there are no massages scheduled' do
        it { expect(appointments.count).to eq 90 }
      end

      context 'when there are 3 massages scheduled' do
        let(:appointments_grouped_by_massage) do
          appointments.group_by { |timetable, masseur, massage| massage }
        end

        before do
          Timecop.freeze(Time.zone.parse('2015-09-11 15:00'))

          timetable = Time.zone.parse('2015-09-14 9:00')

          [masseur1, masseur2, masseur3].each do |masseur|
            create(:massage, masseur: masseur, timetable: timetable)
          end
        end

        it { expect(appointments.count).to eq 90 }
        it { expect(appointments_grouped_by_massage[nil].count).to eq 87 }
      end
    end
  end
end
