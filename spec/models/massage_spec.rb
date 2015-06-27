describe Massage do
  describe 'validations' do
    it { should validate_presence_of(:timetable) }
    it { should validate_presence_of(:masseur_id) }
    it { should validate_presence_of(:user_id) }

    describe '#new' do
      subject(:status) { described_class.new.status }

      it { is_expected.to eq 'pending' }
    end
  end
end
