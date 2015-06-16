describe Panel::BaseController, focus: true do
  describe '#current_user' do
    subject(:current_user) { described_class.new.current_user }

    it { expect(current_user.name).to eq 'Jackie Chan' }
    it { expect(current_user.email).to eq 'jackie@chan.com' }
    it { expect(current_user.status).to eq 'enabled' }
    it { expect(current_user.sector).to eq 'saas' }
  end
end
