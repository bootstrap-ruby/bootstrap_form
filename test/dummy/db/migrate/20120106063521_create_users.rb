class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :password
      t.text :comments
      t.string :status

      t.timestamps
    end
  end
end
