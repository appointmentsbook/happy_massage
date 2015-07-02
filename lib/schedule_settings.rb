module ScheduleSettings
  class << self
    mattr_accessor :massage_duration
    mattr_accessor :massage_start, :massage_end
    mattr_accessor :morning_pause_start, :morning_pause_end
    mattr_accessor :lunch_pause_start, :lunch_pause_end

    def configure
      yield(self)
    end
  end
end