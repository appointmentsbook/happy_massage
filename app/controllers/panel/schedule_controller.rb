class Panel::ScheduleController < Panel::BaseController
  def index
    @schedule_table = Schedule::TableGenerator.schedule_table
  end

  def create
  end

  def new
    @schedule_table = Schedule::TableGenerator.new(Time.zone.today).schedule_table
    @massage = Massage.new
  end
end
