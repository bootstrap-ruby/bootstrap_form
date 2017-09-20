version = Rails.version.to_f
if version < 5.0
  class GenericMigration < ActiveRecord::Migration; end
else
  class GenericMigration < ActiveRecord::Migration[5.0]; end
end
