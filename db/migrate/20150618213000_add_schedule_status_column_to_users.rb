class AddScheduleStatusColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :schedule_status, :string
  end
end