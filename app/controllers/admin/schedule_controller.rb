module Admin
  class ScheduleController < Admin::BaseController
    before_filter :validate_date, only: :index

    def index
      @appointments = Admin::SchedulePresenter.new(params[:date]).appointments
    end

    def confirm_presence
      confirm_with_action(:attend)
    end

    def confirm_absence
      confirm_with_action(:miss)
    end

    private

    def validate_date
      @date_presenter = Appointments::DatePresenter.new(params[:date])
      return if @date_presenter.has_valid_date?

      flash.now[:alert] = t('.select_valid_date') if params[:date]
      render
    end

    def permitted_params
      params.permit(:date)
    end

    def confirm_with_action(action)
      @appointment = Massage.find(params[:id])

      if @appointment.send(action)
        respond_to { |format| format.js { render 'update_appointment_status' } }
      end
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = t('.appointment_not_found')
      redirect_to(admin_schedule_index_path)
    end
  end
end
