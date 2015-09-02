describe Admin::Appointments::DateParser do
  describe '#valid_date?' do
    subject(:valid_date?) { described_class.new(date).valid_date? }

    context 'when date has a valid format' do
      let(:date) { '01/01/2015' }

      it { is_expected.to be true }
    end

    [nil, '', 'lala'].each do |date|
      context 'when date has an invalid format' do
        let(:date) { date }

        it { is_expected.to be false }
      end
    end
  end

  describe '#parsed_date' do
    subject(:parsed_date) { described_class.new(date).parsed_date }

    context 'when date is valid' do
      let(:date) { '01/01/2015' }

      it { is_expected.to eq(Date.parse(date)) }
    end

    [nil, '', 'lala'].each do |date|
      context 'when date is invalid' do
        let(:date) { date }

        it { is_expected.to be nil }
      end
    end
  end
end
