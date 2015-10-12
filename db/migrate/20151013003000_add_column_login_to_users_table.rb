class AddColumnLoginToUsersTable < ActiveRecord::Migration
  def change
    add_column :users, :login, :string
  end
end
