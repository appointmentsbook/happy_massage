module Schedule
  class TableGenerator
    def schedule_table
      @schedule_table ||= begin
        table = []
        x = ScheduleSettings.massage_start
        while x < ScheduleSettings.massage_end do
          if x == ScheduleSettings.morning_pause_start
            x = ScheduleSettings.morning_pause_end
          elsif x == ScheduleSettings.lunch_pause_start
            x = ScheduleSettings.lunch_pause_end
          else
            table << x
            x += 15.minutes
          end
        end
        table
      end
    end
  end
end
