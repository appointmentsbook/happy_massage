describe Panel::BaseController do
  let(:cas_user) { 'jackie.chan' }
  let(:cas_extra_attributes) do
    {
      authorities: ['MASSAGE_ADMIN-N3'],
      cn: 'Jackie Chan',
      email: 'jackie.chan@gmail.com',
      type: type
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
      context 'but it is not an employee' do
        let(:type) { 'Not employee' }

        before { cas_client.fake(cas_user, cas_extra_attributes) }

        after { get :index }

        it 'logs out non employee user' do
          expect(cas_client)
            .to receive(:logout).with(described_class, root_url)
        end
      end

      context 'and it is an employee' do
        let(:type) { 'Employee' }

        before { cas_client.fake(cas_user, cas_extra_attributes) }

        after { get :index }

        it 'logs in employee user' do
          expect(cas_client)
            .not_to receive(:logout).with(described_class, root_url)
        end
      end
    end
  end

  describe '#current_user' do
    context 'when user is not authenticated' do
      before { CASClient::Frameworks::Rails::Filter.fake('not_a_legal_user') }

      after { get :index }

      it { expect(controller.send(:current_user)).to be_nil }
    end

    context 'when user is authenticated' do
      context 'but it is not an employee' do
        let(:type) { 'Not employee' }

        before { cas_client.fake(cas_user, cas_extra_attributes) }

        after { get :index }

        it { expect(controller.send(:current_user)).to be_nil }
      end

      context 'and it is an employee' do
        let(:type) { 'Employee' }

        before { cas_client.fake(cas_user, cas_extra_attributes) }

        after { get :index }

        it { expect(controller.send(:current_user)).to eq(User.last) }
      end
    end
  end
end
