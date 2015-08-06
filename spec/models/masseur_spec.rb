describe Masseur do
  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :email }
  end

  describe '#new' do
    subject { described_class.new.status }

    it { is_expected.to eq('pending') }
  end

  describe '#enable' do
    subject(:status) { masseur.status }

    context 'when previous status was "pending"' do
      let(:masseur) { build(:masseur) }

      before { masseur.save! }

      it { is_expected.to eq('enabled') }
    end

    context 'when previous status was "disabled"' do
      let(:masseur) { create(:masseur, :disabled) }

      before { masseur.enable }

      it { is_expected.to eq('enabled') }

      context 'when disable is run twice' do
        it 'raises an exception' do
          expect { masseur.enable }.to raise_error(AASM::InvalidTransition)
        end
      end
    end
  end

  describe '#disable' do
    subject(:status) { masseur.status }

    context 'when previous status was "enabled"' do
      let(:masseur) { create(:masseur, :enabled) }

      before { masseur.disable }

      it { is_expected.to eq('disabled') }

      context 'when disable is run twice' do
        it 'raises an exception' do
          expect { masseur.disable }.to raise_error(AASM::InvalidTransition)
        end
      end
    end
  end

  describe '.enabled' do
    subject(:enabled) { Masseur.enabled }

    before { 2.times { create(:masseur, :disabled) } }

    context 'when then are no enabled masseurs' do
      it { is_expected.to match_array([]) }
    end

    context 'when there are 2 enabled masseurs and 1 disabled' do
      let!(:masseur1) { create(:masseur, :enabled) }
      let!(:masseur2) { create(:masseur, :enabled) }

      it { is_expected.to match_array([masseur1, masseur2]) }
    end
  end
end
