class AddCommonToUsers < ActiveRecord::Migration
  def change
    add_column :users, :common, :string
  end
end
