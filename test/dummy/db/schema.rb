ActiveRecord::Schema.define(version: 1) do

  create_table :addresses, force: :cascade do |t|
    t.integer :user_id
    t.string  :street
    t.string  :city
    t.string  :state
    t.string  :zip_code
    t.timestamps
  end

  create_table :users, force: :cascade do |t|
    t.string  :email
    t.string  :password
    t.text    :comments
    t.string  :status
    t.string  :misc
    t.text    :preferences
    t.boolean :terms, default: false
    t.string  :type
    t.timestamps
  end

end
