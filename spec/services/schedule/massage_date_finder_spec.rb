describe Schedule::MassageDateFinder do
  describe '#massage_date' do
    subject(:massage_date) { described_class.new(date).massage_date }

    context 'when date does not correspond to a schedule day' do
      context 'and its value correspond to a Sunday' do
        let(:date) { Date.parse('2015-08-02') }

        it { is_expected.to be nil }
      end

      context 'and its value correspond to a Monday' do
        let(:date) { Date.parse('2015-08-03') }

        it { is_expected.to be nil }
      end

      context 'and its value correspond to a Wednesday' do
        let(:date) { Date.parse('2015-08-05') }

        it { is_expected.to be nil }
      end

      context 'and its value correspond to a Saturday' do
        let(:date) { Date.parse('2015-08-08') }

        it { is_expected.to be nil }
      end
    end

    context 'when date corresponds to a schedule day' do
      context 'and its value correspond to a Tuesday' do
        let(:date) { Date.parse('2015-08-04') }

        it { is_expected.to eq(date + 1.day) }
      end

      context 'and its value correspond to a Thursday' do
        let(:date) { Date.parse('2015-08-06') }

        it { is_expected.to eq(date + 1.day) }
      end

      context 'and its value correspond to a Friday' do
        let(:date) { Date.parse('2015-08-07') }

        it { is_expected.to eq(date + 3.days) }
      end
    end
  end
end
