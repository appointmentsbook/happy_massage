module Admin
  class SchedulePresenter
    def initialize(date)
      @date = date
    end

    def appointments
      @appointments ||= begin
        return nil unless date_parser.valid_date?

        AppointmentsBookBuilder.new(date_parser.parsed_date).appointments
      end
    end

    private

    def date_parser
      @date_parser ||= Admin::Appointments::DateParser.new(@date)
    end
  end
end
