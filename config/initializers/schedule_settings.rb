ScheduleSettings = OpenStruct.new(
  Rails.application.config_for(:schedule_settings).symbolize_keys
)