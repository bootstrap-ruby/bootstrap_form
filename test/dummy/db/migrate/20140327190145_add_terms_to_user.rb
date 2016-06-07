class AddTermsToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :terms, :boolean, default: false
  end
end
