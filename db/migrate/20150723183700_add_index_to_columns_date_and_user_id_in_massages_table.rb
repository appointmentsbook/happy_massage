class AddIndexToColumnsDateAndUserIdInMassagesTable < ActiveRecord::Migration
  def change
    add_index 'massages', ['date', 'user_id'], unique: true
  end
end
