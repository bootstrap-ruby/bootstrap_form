# TEST DUMMY APP (Rails 5.2)

Following files were added or changed:

- db/schema.rb
- config/application.rb
- config/routes.rb
- app/models/{address,user,super_user,faux_user}.rb
- app/controllers/bootstrap_controller.rb
- app/views/layouts/application.html.erb
- app/views/bootstrap/form.html.erb

### Usage

- `rake db:schema:load`
- `rails s`
- Navigate to http://localhost:3000
