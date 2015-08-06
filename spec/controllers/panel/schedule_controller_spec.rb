describe Panel::ScheduleController do
  describe 'GET#index' do
    context 'when GET /panel/schedule is perfomed' do
      pending
    end
  end

  describe 'GET#new' do
    let(:available_timetables) do
      Schedule::TimetablesPresenter.new.available_timetables
    end

    context 'when date does not have massage scheduling' do
      before do
        Timecop.freeze(Time.zone.parse('2015-08-05 14:00'))
        get(:new)
      end

      after { Timecop.return }

      it { expect(response).to have_http_status(:success) }
      it { expect(response).to render_template(:new) }
      it { expect(assigns(:available_timetables)).to be_nil }
    end

    context 'when date has massage scheduling' do
      context 'but schedule is not open' do
        before do
          Timecop.freeze(Time.zone.parse('2015-08-06 14:29'))
          get(:new)
        end

        after { Timecop.return }

        it { expect(response).to have_http_status(:success) }
        it { expect(response).to render_template(:new) }
        it { expect(assigns(:available_timetables)).to be_nil }
      end

      context 'and schedule is open' do
        before do
          Timecop.freeze(Time.zone.parse('2015-08-06 15:00'))
          get(:new)
        end

        after { Timecop.return }

        it { expect(response).to have_http_status(:success) }
        it { expect(response).to render_template(:new) }
        it { expect(assigns(:available_timetables)).to eq available_timetables }
      end
    end
  end
end
