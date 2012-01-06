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


Example (HAML)
--------------

    = form_bootstrap_for @user do |f|
      %fieldset
        %legend
          Sign Up
  
        = f.error_message "Please fix the errors below."
  
        = f.text_field :email, label: 'Email Address'
        = f.password_field :password, label: 'Password', help: 'Minimum 6 characters'
        = f.actions 'Sign Up'


Example Output
--------------

    <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
      ...
      <fieldset>
        <legend>
          Sign Up
        </legend>
      
        <div class="clearfix ">
          <label for="user_email">Email</label>
          <div class="input">
            <input id="user_email" name="user[email]" size="30" type="text" />
          </div>
        </div>

        <div class="clearfix ">
          <label for="user_password">Password</label>
          <div class="input">
            <input id="user_password" name="user[password]" size="30" type="password" />
            <span class="help-inline">Minimum 6 characters</span>
          </div>
        </div>

        <div class="actions">
          <input class="btn primary" name="commit" type="submit" value="Sign Up" />
        </div>
      </fieldset>
    </form>
    

Credits
-------

Inspired by Ryan Bates' [Form Builder
Railscast](http://railscasts.com/episodes/311-form-builders)

form-bootstrap is Copyright (c) 2012 Stephen Potenza and is distributed under the MIT license.
