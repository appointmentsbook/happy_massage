module Panel
  class AppointmentsController < Panel::BaseController
    def index
      @appointments_presenter = AppointmentsPresenter.new(current_user)
    end

    def create
      @massage = schedule_massage
      if @massage.persisted?
        flash[:notice] = t('.massage_has_been_scheduled')
        redirect_to root_path
      else
        flash[:alert] = @massage.errors.messages[:timetable].first
        redirect_to :back
      end
    end

    def new
      return unless schedule_is_open

      @massage_date = date_finder.massage_date
      @available_timetables = available_timetables
      @massage = Massage.new
    end

    def destroy
      appointment = Massage.find(params[:id])
      if appointment.cancel!
        flash[:notice] = t('.cancelled')
      else
        flash[:alert] = t('.cannot_cancel')
      end
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = t('.appointment_not_found')
    ensure
      redirect_to root_path
    end

    private

    def schedule_is_open
      @schedule_is_open ||= \
        Schedule::Checker.new(Time.zone.now).schedule_is_open?
    end

    def date_finder
      Schedule::MassageDateFinder.new(Time.zone.today)
    end

    def available_timetables
      Schedule::TimetablesPresenter.new.available_timetables
    end

    def schedule_massage
      Schedule::MassageScheduler.new(massage_params).schedule_massage
    end

    def massage_params
      params.permit(:user, :timetable).merge(user: current_user)
    end
  end
end
