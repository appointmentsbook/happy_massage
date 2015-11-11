class AppointmentsPresenter
  def initialize(user)
    @user = user
  end

  def recent_appointments
    @recent_appointments ||= \
      user_massages
        .scheduled_massages
        .where('timetable > ?', interval_to_be_considered_recent)
  end

  def past_appointments
    @past_appointments ||= user_massages.past_massages
  end

  private

  attr_reader :user

  def user_massages
    @user_massages ||= user.massages.order(timetable: :desc)
  end

  def interval_to_be_considered_recent
    Time.zone.now - ScheduleSettings.massage_duration
  end
end
