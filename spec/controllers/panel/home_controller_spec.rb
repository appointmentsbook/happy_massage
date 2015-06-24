describe Panel::HomeController do
  describe 'GET #index' do
    context 'when GET / is perfomed' do
      before { get :index }

      it { expect(response).to have_http_status(:success) }
      it { expect(response).to render_template(:index) }
    end
  end
end
