describe Sessions::BaseSession do
  let(:session) do
    {
      cas_user: 'jackie.chan',
      cas_extra_attributes: {
        'authorities' => ['MASSAGE_ADMIN-N3'],
        'cn' => 'Jackie Chan',
        'email' => 'jackie.chan@gmail.com',
        'type' => 'Employee'
      }
    }
  end

  let(:user_session) { described_class.new(session) }

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
