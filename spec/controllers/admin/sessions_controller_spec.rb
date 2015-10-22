describe Admin::SessionsController do
  describe 'GET #logout' do
    let(:cas_user) { 'jackie.chan' }
    let(:cas_extra_attributes) do
      {
        'authorities' => ['HAPPY_MASSAGE_ADMIN-N3'],
        'cn' => 'Jackie Chan',
        'email' => 'jackie.chan@gmail.com',
        'type' => 'Employee'
      }
    end

    before do
      CASClient::Frameworks::Rails::Filter.fake(cas_user, cas_extra_attributes)
    end

    after { get :logout }

    it 'calls CASClient::Frameworks::Rails::Filter.logout' do
      expect(CASClient::Frameworks::Rails::Filter)
        .to receive(:logout).with(described_class, admin_root_url)
    end
  end
end
