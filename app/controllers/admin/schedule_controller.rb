module Admin
  class ScheduleController < Admin::BaseController
    before_filter :validate_date, only: :index
    before_action :check_new_status_validatity, only: :update

    def index
      @appointments = Admin::SchedulePresenter.new(params[:date]).appointments
    end

    def confirm_presence
      @appointment = Massage.find(params[:id])

      if @appointment.attend
        respond_to { |format| format.js { render 'update' } }
      end
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = t('.appointment_not_found')
      redirect_to(admin_schedule_index_path)
    end

    def confirm_absence
      @appointment = Massage.find(params[:id])

      if @appointment.miss
        respond_to { |format| format.js { render 'update' } }
      end
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = t('.appointment_not_found')
      redirect_to(admin_schedule_index_path)
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
  end
end
