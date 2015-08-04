module Schedule
  class Checker
    def initialize(time)
      @time = time
    end

    def day_has_schedule?
      @day_has_schedule ||= scheduling_days.include?(@time.strftime('%A'))
    end

    def schedule_is_open?
      @schedule_is_open ||= begin
        day_has_schedule? && time_to_open_schedule_has_been_reached?
      end
    end

    private

    def scheduling_days
      ScheduleSettings.massage_day_given_a_day_with_schedule.keys
    end

    def time_to_open_schedule_has_been_reached?
      @time >= time_to_open_schedule
    end

    def time_to_open_schedule
      hour, minutes = ScheduleSettings.time_to_open_schedule.split(':')
      Time.zone.local(@time.year, @time.month, @time.day, hour, minutes)
    end
  end
end
