describe Panel::ScheduleController do
  describe 'GET #index' do
    context 'when GET /panel/schedule is perfomed' do
      let(:schedule_table) { Schedule::TableGenerator.new.schedule_table }
      before { get :index }

      it { expect(response).to have_http_status(:success) }
      it { expect(response).to render_template(:index) }
      it { expect(assigns(:schedule_table)).to eq schedule_table }
    end
  end
end
