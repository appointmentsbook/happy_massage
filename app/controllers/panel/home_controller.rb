class Panel::HomeController < Panel::BaseController
  def index
    @massages = current_user.massages.order(timetable: :desc)
  end
end
