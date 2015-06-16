module Panel
  class HomeController < ::BaseController
    layout :panel

    def index
      @massages = Massages.all
    end
  end
end
