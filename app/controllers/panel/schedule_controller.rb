class Panel::ScheduleController < Panel::BaseController
  def index
    @schedule_table = Schedule::TableGenerator.new.schedule_table
  end
end
