class AddIndexToColumnsTimetableAsDateAndUserIdInMassagesTable < ActiveRecord::Migration
  def change
    connection ||= ActiveRecord::Base.connection.raw_connection

    ActiveRecord::Base.connection.execute(
      'CREATE UNIQUE INDEX index_massages_on_timetable_date_and_user_id ' + \
      'ON massages (user_id, date(timetable));'
    )
  end
end
