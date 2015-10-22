describe Sessions::AdminUserSession do
  let(:session) do
    {
      cas_user: 'jackie.chan',
      cas_extra_attributes: {
        'authorities' => authorities,
        'cn' => 'Jackie Chan',
        'email' => 'jackie.chan@gmail.com',
        'type' => 'Employee'
      }
    }
  end

  let(:admin_user_session) { described_class.new(session) }

  describe '#admin_user?' do
    context 'when authorities include ADMIN_N2' do
      let(:authorities) { ['HAPPY_MASSAGE_ADMIN-N2'] }

      it { expect(admin_user_session).to be_admin }
    end

    context 'when authorities include ADMIN_N3' do
      let(:authorities) { ['HAPPY_MASSAGE_ADMIN-N3'] }

      it { expect(admin_user_session).to be_admin }
    end

    context 'when authorities do not include massage administrative role' do
      let(:authorities) { [] }

      it { expect(admin_user_session).not_to be_admin }
    end
  end

  describe '#admin_n3?' do
    context 'when authorities include ADMIN_N2' do
      let(:authorities) { ['HAPPY_MASSAGE_ADMIN-N2'] }

      it { expect(admin_user_session).not_to be_admin_n3 }
    end

    context 'when authorities include ADMIN_N3' do
      let(:authorities) { ['HAPPY_MASSAGE_ADMIN-N3'] }

      it { expect(admin_user_session).to be_admin_n3 }
    end

    context 'when authorities do not include massage administrative role' do
      let(:authorities) { [] }

      it { expect(admin_user_session).not_to be_admin_n3 }
    end
  end
end
