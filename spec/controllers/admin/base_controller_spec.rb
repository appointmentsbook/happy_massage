describe Admin::BaseController do
  let(:cas_user) { 'jackie.chan' }
  let(:cas_extra_attributes) do
    {
      'authorities' => authorities,
      'cn' => 'Jackie Chan',
      'email' => 'jackie.chan@gmail.com',
      'type' => 'Employee'
    }
  end
  let(:cas_client) { CASClient::Frameworks::Rails::Filter }

  controller do
    def index
      render nothing: true
    end
  end

  describe 'authentication' do
    context 'when user is not authenticated' do
      before { CASClient::Frameworks::Rails::Filter.fake('not_a_legal_user') }

      after { get :index }

      it 'logs out non legal user' do
        expect(cas_client)
          .to receive(:logout).with(described_class, root_url)
      end
    end

    context 'when user is authenticated' do
      context 'but it is not an admin' do
        let(:authorities) { ['Not admin'] }

        before { cas_client.fake(cas_user, cas_extra_attributes) }

        after { get :index }

        it 'logs out non admin user' do
          expect(cas_client)
            .to receive(:logout).with(described_class, root_url)
        end
      end

      context 'and it is an admin' do
        let(:authorities) { ['HAPPY_MASSAGE_ADMIN-N3'] }

        before { cas_client.fake(cas_user, cas_extra_attributes) }

        after { get :index }

        it 'logs in admin user' do
          expect(cas_client)
            .not_to receive(:logout).with(described_class, root_url)
        end
      end
    end
  end

  describe '#current_admin_user' do
    context 'when user is not authenticated' do
      before { CASClient::Frameworks::Rails::Filter.fake('not_a_legal_user') }

      after { get :index }

      it { expect(controller.send(:current_admin_user)).to be_nil }
    end

    context 'when user is authenticated' do
      context 'but it is not an admin' do
        let(:authorities) { ['Not admin'] }

        before { cas_client.fake(cas_user, cas_extra_attributes) }

        after { get :index }

        it { expect(controller.send(:current_admin_user)).to be_nil }
      end

      context 'and it is an admin' do
        let(:authorities) { ['HAPPY_MASSAGE_ADMIN-N3'] }

        before { cas_client.fake(cas_user, cas_extra_attributes) }

        after { get :index }

        it { expect(controller.send(:current_admin_user)).to eq(User.last) }
      end
    end
  end
end
