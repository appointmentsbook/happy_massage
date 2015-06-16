class AddStatusToMassages < ActiveRecord::Migration
  def change
    add_column :massages, :status, :string
  end
end
