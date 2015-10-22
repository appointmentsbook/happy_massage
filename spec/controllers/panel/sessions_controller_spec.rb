describe Panel::SessionsController do
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

    let(:service) { { service: root_url }.to_query }
    let(:query_string) { "#{service}&gateway=true" }
    let(:url) { "#{ENV['CAS_USERS_BASE_URL']}/logout?#{query_string}" }

    before do
      CASClient::Frameworks::Rails::Filter.fake(cas_user, cas_extra_attributes)
    end

    subject(:logout) { get :logout }

    it 'calls CASClient::Frameworks::Rails::Filter.logout' do
      expect(logout).to redirect_to(url)
    end
  end
end
