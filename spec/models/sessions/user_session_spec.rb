describe Sessions::UserSession do
  let(:session) do
    {
      cas_user: 'jackie.chan',
      cas_extra_attributes: {
        authorities: ['MASSAGE_ADMIN-N3'],
        cn: 'Jackie Chan',
        email: 'jackie.chan@gmail.com',
        type: 'Employee'
      }
    }
  end

  let(:user_session) { described_class.new(session) }

  describe '#employee?' do
    context 'when CAS type is equal to "Employee"' do
      it { expect(user_session).to be_employee }
    end

    context 'when CAS type is not equal to "Employee"' do
      before do
        session.merge!(cas_extra_attributes: { type: 'Customer' })
      end

      it { expect(user_session).not_to be_employee }
    end

    context 'when cas_extra_attributes is not present' do
      let(:session) { { cas_user: 'jackie.chan' } }

      it { expect(user_session).not_to be_employee }
    end
  end

  describe '#login' do
    subject(:login) { user_session.login }

    it { is_expected.to eq 'jackie.chan' }
  end

  describe '#name' do
    subject(:name) { user_session.name }

    it { is_expected.to eq 'Jackie Chan' }
  end

  describe '#email' do
    subject(:email) { user_session.email }

    it { is_expected.to eq 'jackie.chan@gmail.com' }
  end
end
