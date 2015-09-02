describe Admin::Appointments::DatePresenter do
  describe '#formatted_date' do
    subject(:formatted_date) { described_class.new(date).formatted_date }

    context 'when date has a valid format' do
      let(:date) { '01/01/2015' }

      it { is_expected.to eq date }
    end

    [nil, '', 'lala'].each do |date|
      context 'when date has an invalid format' do
        let(:date) { date }

        it { is_expected.to eq('') }
      end
    end
  end

  describe '#has_valid_date?' do
    subject(:formatted_date) { described_class.new(date).has_valid_date? }

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
end
