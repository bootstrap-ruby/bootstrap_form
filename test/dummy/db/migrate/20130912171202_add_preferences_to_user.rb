class AddPreferencesToUser < GenericMigration
  def change
    add_column :users, :preferences, :text
  end
end
