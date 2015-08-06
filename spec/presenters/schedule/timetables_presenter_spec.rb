describe Schedule::TimetablesPresenter do
  describe '#available_timetables' do
    let(:time) { Time.zone.parse('2015-08-04 15:00') }
    let(:masseur1) { create(:masseur) }
    let(:masseur2) { create(:masseur) }
    let(:masseur3) { create(:masseur) }

    let(:schedule_table) do
      Schedule::TableGenerator.new(1.day.from_now).schedule_table.map(&:utc)
    end

    let(:scheduled_massages) do
      Massage
        .where("date(timetable) = ?", 1.day.from_now.to_date)
        .group(:timetable).count(:id)
    end

    subject(:available_timetables) do
      described_class.new.available_timetables
    end

    before do
      Timecop.freeze(time)

      create(:massage, timetable: '2015-08-05 9:00', masseur: masseur1)
      create(:massage, timetable: '2015-08-05 9:00', masseur: masseur2)
      create(:massage, timetable: '2015-08-05 9:00', masseur: masseur3)

      create(:massage, timetable: '2015-08-05 17:45', masseur: masseur1)
      create(:massage, timetable: '2015-08-05 17:45', masseur: masseur2)
    end

    after { Timecop.return }

    context 'lala' do
      it { expect(available_timetables.count).to eq(29) }

      context 'first timetable' do
        it 'has 3 massages left' do
          expect(available_timetables.first)
            .to eq([Time.zone.parse('2015-08-05 9:15'), 3])
        end
      end

      %w(10:00 11:00 14:30 16:00 17:00).each do |time|
        context 'timetables between first and last' do
          let(:timetable) { Time.zone.parse("2015-08-05 #{time}") }

          it 'has 3 massages left' do
            expect(available_timetables).to include([timetable, 3])
          end
        end
      end

      context 'last timetable' do
        it 'has 1 massage left ' do
          expect(available_timetables.last)
            .to eq([Time.zone.parse('2015-08-05 17:45'), 1])
        end
      end
    end
  end
end
