class AddUserRefToMassages < ActiveRecord::Migration
  def change
    add_reference :massages, :user, index: true, foreign_key: true
  end
end