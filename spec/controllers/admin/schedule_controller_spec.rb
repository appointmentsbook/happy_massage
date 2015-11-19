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
    before { request.env['HTTP_REFERER'] = admin_schedule_index_path }

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

  describe 'PUT #confirm_presence' do
    let(:params) do
      {
        id: id,
        format: :js
      }
    end

    before do
      request.env['HTTP_REFERER'] = admin_schedule_index_path

      Timecop.travel(Time.zone.parse('2015-09-22 15:00')) do
        create(:massage, timetable: Time.zone.parse('2015-09-23 9:00'))
      end
    end

    context 'when massage is not found' do
      let(:id) { Massage.first.id + 1 }
      let(:appointment_not_found) { 'Massagem não encontrada.' }

      before { put(:confirm_presence, params) }

      it { is_expected.to set_flash[:alert].to(appointment_not_found) }
      it { is_expected.to redirect_to admin_schedule_index_path }
    end

    context 'when massage is found' do
      let(:id) { Massage.first.id }

      before { put(:confirm_presence, params) }

      it { expect(response).to have_http_status(:success) }
      it { expect(assigns(:appointment)).to eq Massage.first }
      it { expect(assigns(:appointment).status).to eq 'attended' }
    end
  end

  describe 'PUT #confirm_absence' do
    let(:params) do
      {
        id: id,
        format: :js
      }
    end

    before do
      request.env['HTTP_REFERER'] = admin_schedule_index_path

      Timecop.travel(Time.zone.parse('2015-09-22 15:00')) do
        create(:massage, timetable: Time.zone.parse('2015-09-23 9:00'))
      end
    end

    context 'when massage is not found' do
      let(:id) { Massage.first.id + 1 }
      let(:appointment_not_found) { 'Massagem não encontrada.' }

      before { put(:confirm_absence, params) }

      it { is_expected.to set_flash[:alert].to(appointment_not_found) }
      it { is_expected.to redirect_to admin_schedule_index_path }
    end

    context 'when massage is found' do
      let(:id) { Massage.first.id }

      before { put(:confirm_absence, params) }

      it { expect(response).to have_http_status(:success) }
      it { expect(assigns(:appointment)).to eq Massage.first }
      it { expect(assigns(:appointment).status).to eq 'missed' }
    end
  end
end
