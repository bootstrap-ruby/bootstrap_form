class AddPreferencesToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :preferences, :text
  end
end
