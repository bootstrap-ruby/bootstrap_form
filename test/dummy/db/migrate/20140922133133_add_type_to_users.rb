class AddTypeToUsers < GenericMigration
  def change
    add_column :users, :type, :string
  end
end
