describe Schedule::Checker do
  describe '#day_has_schedule' do
    subject(:day_has_schedule?) do
      described_class.new(time).day_has_schedule?
    end

    [1, 2, 3, 5].each do |day|
      context 'when day does not correspond to a scheduling one' do
        let(:time) { Time.zone.local(2015, 8, day) }

        it { is_expected.to be false }
      end
    end

    [4, 6, 7].each do |day|
      context 'when day correponds to a scheduling one' do
        let(:time) { Time.zone.local(2015, 8, day, 14, 00) }

        it { is_expected.to be true }
      end
    end
  end

  describe '#schedule_is_open?' do
    subject(:schedule_is_open?) do
      described_class.new(time).schedule_is_open?
    end

    [1, 2, 3, 5].each do |day|
      context 'when day does not correspond to a scheduling one' do
        let(:time) { Time.zone.local(2015, 8, day) }

        it { is_expected.to be false }
      end
    end

    [4, 6, 7].each do |day|
      context 'when day correponds to a scheduling one' do
        context 'but the schedule is not open yet' do
          let(:time) { Time.zone.local(2015, 8, day, 14, 00) }

          it { is_expected.to be false }
        end

        context 'and the schedule is already open' do
          let(:time) { Time.zone.local(2015, 8, day, 15, 00) }

          it { is_expected.to be true }
        end
      end
    end
  end
end
