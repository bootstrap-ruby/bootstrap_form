bootstrap_form
==============

Provides a rails form builder that makes it simple to use Twitter Bootstrap 2.0 forms.


Requirements
------------

* Ruby 1.9+
* Rails 3.1+
* Twitter Bootstrap 2.0+ -- I use [less-rails-bootstrap](https://github.com/metaskills/less-rails-bootstrap.git)


Installation
------------

Add the gem to your Gemfile

    gem 'bootstrap_form'

Install the gem

    bundle

Add bootstrap_form to your application.css file

    /*
     *= require bootstrap_form
    */
    
This brings in a couple of minor css classes that help format helper and
error messages.

Usage
-----

This is an example of the default form style, which stacks the labels on
top of the inputs and places helper text to the right of the field:

    <%= bootstrap_form_for(@user) do |f| %>
      <%= f.alert_message "Please fix the errors below." %>

      <%= f.text_field :email, autofocus: :true %>
      <%= f.password_field :password, help: 'Must be at least 6 characters long' %>
      <%= f.password_field :password_confirmation, label: 'Confirm Password' %>

      <%= f.actions do %>
        <%= f.primary 'Sign Up' %>
      <% end %>
    <% end %>

![Example Form](https://github.com/potenza/bootstrap_form/raw/master/assets/example_form.png)


To use a horizontal-style form with labels to the left of the inputs,
add the `.form-horizontal` class:

    <%= bootstrap_form_for(@user, html: { class: 'form-horizontal' }) do |f| %>


To place helper text underneath the fields, pass the option `help:
:block`:

    <%= bootstrap_form_for(@user, help: block) do |f| %>


Validation Errors
-----------------

When a validation error is triggered, the field will be outlined and the
error will be displayed next to the field. Rails normally wraps fields
in a div (field_with_errors), but this behavior is suppressed when `bootstrap_form_for` is called.

![Example form with errors](https://github.com/potenza/bootstrap_form/raw/master/assets/example_form_error.png)


Credits
-------

Inspired by Ryan Bates' [Form Builder
Railscast](http://railscasts.com/episodes/311-form-builders)

bootstrap_form is Copyright (c) 2012 Stephen Potenza and is distributed under the MIT license.
