class AddIndexToColumnsMasseurIdAndTimetableInMassagesTable < ActiveRecord::Migration
  def change
    add_index 'massages', ['timetable', 'masseur_id'], unique: true
  end
end