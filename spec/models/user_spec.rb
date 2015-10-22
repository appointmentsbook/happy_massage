describe User do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:login) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
  end

  describe '.retrieve_from' do
    subject(:retrieve_from) { described_class.retrieve_from(user_session) }

    context 'when user is not created yet' do
      let(:user_session) do
        double(
          :user_session,
          login: 'jackie.chan',
          name: 'Jackie Chan',
          email: 'jackie.chan@lala.popo'
        )
      end

      before { retrieve_from }

      it 'returns the created user' do
        expect(User.last)
          .to have_attributes(
            login: 'jackie.chan',
            name: 'Jackie Chan',
            email: 'jackie.chan@lala.popo'
          )
      end
    end

    context 'when user is already created' do
      let!(:user) { create(:user) }
      let(:user_session) do
        double(
          :user_session,
          login: user.login,
          name: user.name,
          email: user.email
        )
      end

      before { retrieve_from }

      it { is_expected.to eq user }
      it { expect(User.count).to eq 1 }
    end
  end
end
