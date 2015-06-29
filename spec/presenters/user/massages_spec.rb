describe User::Massages do
  let(:user) { create(:user, status: :enabled) }
  let(:masseur) { create(:masseur) }

  describe '#historical' do
    subject(:historical) { described_class.new(user).historical }

    context 'when no massages were scheduled' do
      it { is_expected.to be_nil }
    end

    context 'when some massages were scheduled' do
      let!(:massage1) { create(:massage, status: 'scheduled', user_id: user.id, masseur_id: masseur.id) }
      let!(:massage2) { create(:massage, status: 'attended', user_id: user.id, masseur_id: masseur.id) }
      let!(:massage3) { create(:massage, status: 'cancelled', user_id: user.id, masseur_id: masseur.id) }
      let!(:massage4) { create(:massage, status: 'missed', user_id: user.id, masseur_id: masseur.id) }

      it { is_expected.to eq }
    end
  end
end