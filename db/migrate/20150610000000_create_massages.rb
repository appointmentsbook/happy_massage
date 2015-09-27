class CreateMassages < ActiveRecord::Migration
  def change
    create_table :massages do |t|
      t.datetime :timetable
      t.string :masseur
      t.date :date
      t.string :location

      t.timestamps
    end
  end
end
