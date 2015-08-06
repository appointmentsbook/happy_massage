module Schedule
  class TableGenerator
    def initialize(massage_date)
      @massage_date = massage_date
    end

    def schedule_table
      @schedule_table ||= begin
        year = @massage_date.year
        month = @massage_date.month
        day = @massage_date.day
        massage_schedules(year, month, day) - pauses(year, month, day)
      end
    end

    private

    def time_for(time_expression)
      Time.zone.parse(ScheduleSettings.send(time_expression))
    end

    def massage_schedules(year, month, day)
      massage_interval = time_for(:massage_end) - time_for(:massage_start)
      massages = (massage_interval / ScheduleSettings.massage_duration - 1).to_i

      initial_hour, initial_minutes = ScheduleSettings.massage_start.split(':')
      initial = Time.zone.local(year, month, day, initial_hour, initial_minutes)

      massage_schedules = massages.times.each_with_object([initial]) do |_, acc|
        acc << acc.last + ScheduleSettings.massage_duration
      end
    end

    def pauses(year, month, day)
      pauses = []
      ScheduleSettings.pauses.each do |pause_start, pause_end|
        pause_interval = Time.zone.parse(pause_end) - Time.zone.parse(pause_start)
        pause = (pause_interval / ScheduleSettings.massage_duration - 1).to_i

        initial_hour, initial_minutes = pause_start.split(':')
        initial = Time.zone.local(year, month, day, initial_hour, initial_minutes)

        pauses += pause.times.each_with_object([initial]) do |_, acc|
          acc << acc.last + ScheduleSettings.massage_duration
        end
      end
      pauses
    end

    # Refactor methods above using this
    def generate_timetables(first, last, interval)
      (initial.to_i..final.to_i).step(interval).map { |t| Time.zone.at(t) }
    end
  end
end
