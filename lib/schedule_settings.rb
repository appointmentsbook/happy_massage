module ScheduleSettings
  class << self
    mattr_accessor(
      :massage_duration, :massage_start, :massage_end,
      :pauses, :massage_day_given_a_day_with_schedule,
      :time_to_open_schedule
    )

    def configure
      yield(self)
    end
  end
end