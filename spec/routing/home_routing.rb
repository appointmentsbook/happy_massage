describe HomeController do
  describe 'routing', type: :routing do
    it { expect(:get => '/').to route_to('home#lala') }
  end
end
