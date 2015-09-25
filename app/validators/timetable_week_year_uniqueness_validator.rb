class TimetableWeekYearUniquenessValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if record.user.nil? || record.timetable.nil?

    validate_week_year_uniqueness(record, attribute)
  end

  private

  def validate_week_year_uniqueness(record, attribute)
    return if record.errors[attribute].any?
    return if user_has_not_scheduled_this_week_in_this_year?(record)

    record.errors.add(attribute, :timetable_week_and_year_are_not_unique)
  end

  def user_has_not_scheduled_this_week_in_this_year?(record)
    user_massages_for_this_week_in_this_year(
      record.user, record.timetable
    ).empty?
  end

  def user_massages_for_this_week_in_this_year(user, timetable)
    user
      .massages
      .where(
        'date >= ? and date <= ?',
        timetable.beginning_of_week,
        timetable.end_of_week
      )
  end
end
