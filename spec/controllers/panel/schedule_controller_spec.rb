describe Panel::ScheduleController do
  describe 'GET #index' do
    context 'when GET /panel/schedule is perfomed' do
      before { get :index }

      it { expect(response).to have_http_status(:success) }
      it { expect(response).to render_template(:index) }
    end
  end
end
