ScheduleSettings.configure do |config|
  config.massage_duration = 15.minutes
  config.massage_start = Time.zone.parse('9h00')
  config.massage_end = Time.zone.parse('18h00')
  config.morning_pause_start = Time.zone.parse('10h30')
  config.morning_pause_end = Time.zone.parse('10h45')
  config.lunch_pause_start = Time.zone.parse('13h15')
  config.lunch_pause_end = Time.zone.parse('14h30')
end