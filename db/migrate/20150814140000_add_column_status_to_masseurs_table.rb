class AddColumnStatusToMasseursTable < ActiveRecord::Migration
  def change
    add_column :masseurs, :status, :string
  end
end
