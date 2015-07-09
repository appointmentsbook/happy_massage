class TimetableValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    validate_schedule_is_open(record, attribute, value)
    validate_schedule_table_contains_timetable(record, attribute, value)
  end

  private

  def validate_schedule_is_open(record, attribute, value)
    return if schedule_is_open?

    record.errors.add(attribute, :schedule_is_not_open)
  end

  def schedule_is_open?
    @schedule_is_open ||= begin
      Schedule::Checker.new(Time.zone.now).schedule_is_open?
    end
  end

  def validate_schedule_table_contains_timetable(record, attribute, value)
    return if record.errors[attribute].any?
    return if massage_date.present? && schedule_table.include?(value)

    record.errors.add(attribute, :timetable_is_out_of_range)
  end

  def schedule_table
    @schedule_table ||= begin
      Schedule::TableGenerator.new(massage_date: massage_date).schedule_table
    end
  end

  def massage_date
    @massage_date ||= begin
      Schedule::MassageDateFinder.new(Time.zone.today).massage_date
    end
  end
end
