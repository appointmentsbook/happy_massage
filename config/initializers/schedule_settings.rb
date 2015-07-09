ScheduleSettings.configure do |config|
  config.massage_duration = 15.minutes
  config.massage_start = '9:00'
  config.massage_end = '18:00'
  config.pauses = [['10:30', '10:45'], ['13:15', '14:30']]
  config.massage_day_given_a_day_with_schedule = {
    'Friday' => 'Monday',
    'Tuesday' => 'Wednesday',
    'Thursday' => 'Friday'
  }
  config.time_to_open_schedule = '14:30'
end
