class AddStatusToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :status, :boolean, default: false, null: false
  end
end