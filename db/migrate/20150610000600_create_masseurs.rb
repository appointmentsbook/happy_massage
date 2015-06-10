class CreateMasseurs < ActiveRecord::Migration
  def change
    create_table :masseurs do |t|
      t.string :name
      t.string :email
    end
  end
end
