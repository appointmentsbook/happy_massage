describe Admin::BaseController do
  describe '#current_user' do
    subject(:current_user) { described_class.new.current_user }

    it { expect(current_user.name).to eq 'Jackie Chan' }
    it { expect(current_user.email).to eq 'jackie@chan.com' }
  end
end
