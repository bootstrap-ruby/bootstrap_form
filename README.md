form-bootstrap
==============

This is a simple extraction from a personal project that provides
a Rails Form Builder intended for use with Twitter Bootstrap.

This has been extracted from a Rails 3.1 project and expects that you
already have bootstrap setup in your project. I use
[less-rails-bootstrap](https://github.com/metaskills/less-rails-bootstrap).


Requirements
------------

* Ruby 1.9+
* Rails 3.1+
* [Twitter Bootstrap](http://twitter.github.com/bootstrap/)


Usage
-----

Add the gem to your Gemfile

    gem 'form-bootstrap'

Install the gem

    bundle

Add the following to your application.rb file to prevent Rails from wrapping your
input fields with a div on a validation error:

    ActionView::Base.field_error_proc = proc { |input, instance| input }


Example Form
------------

    <%= form_bootstrap_for(@user, help: :block) do |f| %>
      <fieldset>
        <legend>Sign Up Today!</legend>
        <%= f.alert_message "Please fix the errors below." %>

        <%= f.text_field :email, autofocus: :true %>
        <%= f.password_field :password, help: 'Must be at least 6 characters long' %>
        <%= f.password_field :password_confirmation, label: 'Confirm Password' %>
        <%= f.actions 'Sign Up' %>
      </fieldset>
    <% end %>


Example Output
--------------

    <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
      ...
      <fieldset>
        <legend>Sign Up Today!</legend>

        <div class="clearfix">
          <label for="user_email">Email</label>
          <div class="input">
            <input id="user_email" name="user[email]" size="30" type="text" />
          </div>
        </div>
        <div class="clearfix">
          <label for="user_password">Password</label>
          <div class="input">
            <input id="user_password" name="user[password]" size="30" type="password" />
            <span class="help-block">Must be at least 6 characters long</span>
          </div>
        </div>
        <div class="clearfix">
          <label for="user_password_confirmation">Confirm Password</label>
          <div class="input">
            <input id="user_password_confirmation" name="user[password_confirmation]" size="30" type="password" />
          </div>
        </div>
        <div class="actions">
          <input class="btn primary" name="commit" type="submit" value="Sign Up" />
        </div>
      </fieldset>
    </form>


Screenshots
-----------

![Example Form](https://github.com/potenza/form-bootstrap/raw/master/assets/example_form.png)

![Example form with errors](https://github.com/potenza/form-bootstrap/raw/master/assets/example_form_error.png)


Options
-------

By default, help (and error) messages will be placed to the right of the
input field. If you want to place them under the input field, pass the option
`help: :block`:

    <%= form_bootstrap_for @user, help: :block do |f| %>


Credits
-------

Inspired by Ryan Bates' [Form Builder
Railscast](http://railscasts.com/episodes/311-form-builders)

form-bootstrap is Copyright (c) 2012 Stephen Potenza and is distributed under the MIT license.
