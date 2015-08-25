class AppointmentsPresenter
  def initialize(user)
    @user = user
  end

  def next_appointments
    @next_appointments ||= user_massages.next_massages
  end

  def past_appointments
    @past_appointments ||= user_massages.past_massages
  end

  private

  def user_massages
    @user.massages.order(timetable: :desc)
  end
end
