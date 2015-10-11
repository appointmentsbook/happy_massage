module Schedule
  class MassageDateFinder
    def initialize(schedule_date)
      @schedule_date = schedule_date
    end

    def massage_date
      @massage_date ||= begin
        return if !Schedule::Checker.new(@schedule_date).day_has_schedule?

        @schedule_date.advance(days: remaining_days_for_massage)
      end
    end

    private

    def remaining_days_for_massage
      massage_wday = massage_wday(massage_day)
      diff = massage_wday - @schedule_date.wday
      diff > 0 ? diff.days : (7 + diff).days
    end

    def massage_day
      @massage_day ||= begin
        massage_day_given_a_day_with_schedule(@schedule_date.strftime('%A'))
      end
    end

    def massage_day_given_a_day_with_schedule(week_day)
      ScheduleSettings.massage_day_given_a_day_with_schedule[week_day]
    end

    def massage_wday(massage_day)
      wdays_hash[massage_day]
    end

    def wdays_hash
      @wdays_hash ||= Hash[Date::DAYNAMES.zip(0..Date::DAYNAMES.length)]
    end
  end
end
