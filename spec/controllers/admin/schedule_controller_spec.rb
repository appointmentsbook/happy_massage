describe Admin::ScheduleController do
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

  describe 'GET #index' do
    before { request.env['HTTP_REFERER'] = admin_schedule_path }

    context 'when date is invalid' do
      before { get(:index) }

      it { expect(response).to have_http_status(:success) }
      it { is_expected.to render_with_layout(:admin) }
      it { is_expected.to render_template(:index) }
      it { expect(assigns(:appointments)).to be_nil }
    end

    context 'when date is valid' do
      context 'and there are no masseurs' do
        before { get(:index, date: '2015-01-01') }

        it { expect(response).to have_http_status(:success) }
        it { is_expected.to render_with_layout(:admin) }
        it { is_expected.to render_template(:index) }
        it { expect(assigns(:appointments)).to be_empty }
      end

      context 'and there is at least one masseur' do
        let!(:masseur) { create(:masseur) }

        before { get(:index, date: '2015-01-01') }

        it { expect(response).to have_http_status(:success) }
        it { is_expected.to render_with_layout(:admin) }
        it { is_expected.to render_template(:index) }

        it 'assigns @appointments a non empty array' do
          expect(assigns(:appointments)).not_to be_empty
        end
      end
    end
  end

  describe 'PATCH #update' do
    let(:params) do
      {
        id: id,
        massage_new_status: new_status
      }
    end

    before do
      request.env['HTTP_REFERER'] = admin_schedule_path

      Timecop.travel(Time.zone.parse('2015-09-22 15:00')) do
        create(:massage, timetable: Time.zone.parse('2015-09-23 9:00'))
      end
    end

    context 'when massage is not found' do
      let(:id) { Massage.first.id + 1 }
      let(:new_status) { 'attended' }
      let(:appointment_not_found) { 'Massagem não encontrada.' }

      before { patch(:update, params) }

      it { is_expected.to set_flash[:alert].to(appointment_not_found) }
      it { is_expected.to redirect_to admin_schedule_path }
    end

    context 'when massage is found' do
      let(:attended_message) { 'Comparecimento contabilizado com sucesso.' }
      let(:missed_message) { 'Falta contabilizada com sucesso.' }
      let(:id) { Massage.first.id }

      context 'when previous status was scheduled' do
        context 'and next status is attended' do
          let(:new_status) { 'attended' }

          before { patch(:update, params) }

          it { is_expected.to set_flash[:notice].to(attended_message) }
          it { is_expected.to redirect_to admin_schedule_path }
        end

        context 'and next status is missed' do
          let(:new_status) { 'missed' }

          before { patch(:update, params) }

          it { is_expected.to set_flash[:notice].to(missed_message) }
          it { is_expected.to redirect_to admin_schedule_path }
        end
      end
    end
  end
end
