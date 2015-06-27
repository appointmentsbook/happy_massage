class AddMasseurRefToMassagesAndRemoveMasseurColumn < ActiveRecord::Migration
  def change
    add_reference :massages, :masseur, index: true, foreign_key: true
    remove_column :massages, :masseur
  end
end