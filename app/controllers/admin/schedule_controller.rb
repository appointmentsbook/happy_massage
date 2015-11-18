module Admin
  class ScheduleController < Admin::BaseController
    before_filter :validate_date, only: :index
    before_action :check_new_status_validatity, only: :update

    def index
      @appointments = Admin::SchedulePresenter.new(params[:date]).appointments
    end

    def update
      @appointment = Massage.find(params[:id])
      if update_appointment!(@appointment)
        respond_to do |format|
          format.html { flash[:notice] = t(".new_status.#{massage_new_status}") }
          format.js
        end
      end
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = t('.appointment_not_found')
      redirect_to :back
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

    def check_new_status_validatity
      flash[:alert] = t('.invalid_action') if massage_new_status_is_invalid?
    end

    def massage_new_status
      params[:massage_new_status]
    end

    def update_appointment!(appointment)
      if massage_new_status == 'attended'
        appointment.attend
      elsif massage_new_status == 'missed'
        appointment.miss
      end
    end

    def massage_new_status_is_invalid?
      !massage_allowed_actions.include?(massage_new_status)
    end

    def massage_allowed_actions
      %w(attended missed)
    end
  end
end
