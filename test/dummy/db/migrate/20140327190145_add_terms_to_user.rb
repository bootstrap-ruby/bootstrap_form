class AddTermsToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :terms, :boolean, default: false
  end
end
