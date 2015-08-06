class Panel::ScheduleController < Panel::BaseController
  def create
    @massage = Schedule::MassageScheduler.new(massage_params).schedule_massage
    if @massage.persisted?
      flash[:notice] = t(:massage_has_been_scheduled)
      redirect_to root_path
    else
      flash[:alert] = @massage.errors.messages[:timetable].first
      redirect_to :back
    end
  end

  def new
    @schedule_is_open = Schedule::Checker.new(Time.zone.now).schedule_is_open?
    if @schedule_is_open
      @available_timetables = Schedule::TimetablesPresenter.new.available_timetables
      @massage = Massage.new
    end
  end

  private

  def massage_params
    params.permit(:user, :timetable).merge(user: current_user)
  end
end
