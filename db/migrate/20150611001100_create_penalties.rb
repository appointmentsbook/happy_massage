class CreatePenalties < ActiveRecord::Migration
  def change
    create_table :penalties do |t|
      t.datetime :punished_at
      t.datetime :punished_until
      t.string :reported_by
    end
  end
end
