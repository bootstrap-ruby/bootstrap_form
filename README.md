[![Build Status](https://travis-ci.org/bootstrap-ruby/rails-bootstrap-forms.png)](https://travis-ci.org/bootstrap-ruby/rails-bootstrap-forms)
[![Gem Version](https://badge.fury.io/rb/bootstrap_form.svg)](http://badge.fury.io/rb/bootstrap_form)

# Rails Bootstrap Forms

**Rails Bootstrap Forms** is a rails form builder that makes it super easy to integrate
twitter bootstrap-style forms into your rails application.

## Requirements

* Ruby 1.9+
* Rails 4.0+
* Twitter Bootstrap 3.0+

## Installation

Add it to your Gemfile:

`gem 'bootstrap_form'`

Then:

`bundle`

Then require the CSS in your `application.css` file:

```css
/*
 *= require rails_bootstrap_forms
 */
```

## Usage

To get started, just use the `bootstrap_form_for` helper. Here's an example:

```erb
<%= bootstrap_form_for(@user) do |f| %>
  <%= f.email_field :email %>
  <%= f.password_field :password %>
  <%= f.check_box :remember_me %>
  <%= f.submit %>
<% end %>
```

This generates the following HTML:

```html
<form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
  <div class="form-group">
    <label for="user_email">Email</label>
    <input class="form-control" id="user_email" name="user[email]" type="email">
  </div>
  <div class="form-group">
    <label for="user_password">Password</label>
    <input class="form-control" id="user_password" name="user[password]" type="password">
  </div>
  <div class="checkbox">
    <label for="user_remember_me">
      <input name="user[remember_me]" type="hidden" value="0">
      <input id="user_remember_me" name="user[remember_me]" type="checkbox" value="1"> Remember me
    </label>
  </div>
  <input class="btn btn-default" name="commit" type="submit" value="Log In">
</form>
```

### Nested Forms

In order to active [nested_form](https://github.com/ryanb/nested_form) support,
use `bootstrap_nested_form_for` instead of `bootstrap_form_for`.

### bootstrap_form_tag

If your form is not backed by a model, use the `bootstrap_form_tag`. Usage of this helper is the same as `bootstrap_form_for`, except no model object is passed in as the first argument. Here's an example:

```erb
<%= bootstrap_form_tag url: '/subscribe' do |f| %>
  <%= f.email_field :email, value: 'name@example.com' %>
  <%= f.submit %>
<% end %>
```

## Form Helpers

This gem wraps the following Rails form helpers:

* check_box
* check_boxes_collection
* collection_select
* color_field
* date_field
* date_select
* datetime_field
* datetime_local_field
* datetime_select
* email_field
* file_field
* grouped_collection_select
* hidden_field (not wrapped, but supported)
* month_field
* number_field
* password_field
* phone_field
* radio_button
* radio_buttons_collection
* range_field
* search_field
* select
* telephone_field
* text_area
* text_field
* time_field
* time_select
* time_zone_select
* url_field
* week_field

These helpers accept the same options as the standard Rails form helpers, with
a few extra options:

### Labels

Use the `label` option if you want to specify the field's label text:

```erb
<%= f.password_field :password_confirmation, label: "Confirm Password" %>
```

To hide a label, use the `hide_label: true` option. This adds the `sr-only`
class, which keeps your labels accessible to those using screen readers.

```erb
<%= f.text_area :comment, hide_label: :true, placeholder: "Leave a comment..." %>
```

### Help Text

To add help text, use the `help` option:

```erb
<%= f.password_field :password, help: "Must be at least 6 characters long" %>
```

### Prepending and Appending Inputs

You can pass `prepend` and/or `append` options to input fields:

```erb
<%= f.text_field :price, prepend: "$", append: ".00" %>
```

You can also prepend and append buttons. Note: The buttons must contain the
`btn` class to generate the correct markup.

```erb
<%= f.text_field :search, append: link_to("Go", "#", class: "btn btn-default") %>
```

### Additional Form Group Classes

If you want to add an additional css class to the form group div, you can use
the `wrapper_class: 'additional-class'` option.

```erb
<%= f.text_field :name, wrapper_class: 'has-warning' %>
```

Which produces the following output:

```erb
<div class="form-group has-warning">
  <label class="control-label" for="user_name">Id</label>
  <input class="form-control" id="user_name" name="user[name]" type="text">
</div>
```

### Checkboxes and Radios

Checkboxes and radios should be placed inside of a `form_group` to render
properly. The following example ensures that the entire form group will display
an error if an associated validations fails:

```erb
<%= f.form_group :skill_level, label: { text: "Skill" }, help: "Optional Help Text" do %>
  <%= f.radio_button :skill_level, 0, label: "Novice", checked: true %>
  <%= f.radio_button :skill_level, 1, label: "Intermediate" %>
  <%= f.radio_button :skill_level, 2, label: "Advanced" %>
<% end %>

<%= f.form_group :terms do %>
  <%= f.check_box :terms, label: "I agree to the Terms of Service" %>
<% end %>
```

You can also create a checkbox using a block:

```erb
<%= f.form_group :terms, label: { text: "Optional Label" } do %>
  <%= f.check_box :terms do %>
    You need to check this box to accept our terms of service and privacy policy
  <% end %>
<% end %>
```

To display checkboxes and radios inline, pass the `inline: true` option:

```erb
<%= f.form_group :skill_level, label: { text: "Skill" } do %>
  <%= f.radio_button :skill_level, 0, label: "Novice", inline: true %>
  <%= f.radio_button :skill_level, 1, label: "Intermediate", inline: true %>
  <%= f.radio_button :skill_level, 2, label: "Advanced", inline: true %>
<% end %>
```

#### Collections

BootstrapForms also provideshelpers that automatically creates the
`form_group` and the `radio_button`s or `check_box`es for you:

```erb
<%= f.radio_buttons_collection :skill_level, Skill.all, :id, :name %>
<%= f.check_boxes_collection :skills, Skill.all, :id, :name %>
```

Collection methods accept these options:
* `:label`: Customize the `form_group`'s label
* `:hide_label`: Pass true to hide the `form_group`'s label
* `:help`: Add a help span to the `form_group`
* Other options will be forwarded to the `radio_button`/`check_box` method

### Static Controls

You can create a static control like this:

```erb
<%= f.static_control :email %>
```

Here's the output:

```html
<div class="form-group">
  <label class="col-sm-2 control-label" for="user_email">Email</label>
  <div class="col-sm-10">
    <p class="form-control-static">test@email.com</p>
  </div>
</div>
```

You can also create a static control that isn't based on a model attribute:

```erb
<%= f.static_control label: "Custom Static Control" do %>
  Content Here
<% end %>
```

### Date Helpers

The multiple selects that the date and time helpers (`date_select`,
`time_select`, `datetime_select`) generate are wrapped inside a
`div.rails-bootstrap-forms-[date|time|datetime]-select` tag. This is because
Boostrap automatically stylizes ours controls as `block`s. This wrapper fix
this defining these selects as `inline-block` and a width of `auto`.

### Submit Buttons

The `btn btn-default` css classes are automatically added to your submit
buttons.

```erb
<%= f.submit %>
```

You can also use the `primary` helper, which adds `btn btn-primary` to your
submit button **(master branch only)**:

```erb
<%= f.primary "Optional Label" %>
```

You can specify your own classes like this:

```erb
<%= f.submit "Log In", class: "btn btn-success" %>
```

### Accessing Rails Form Helpers

If you want to use the original Rails form helpers for a particular field,
append `_without_bootstrap` to the helper:

```erb
<%= f.text_field_without_bootstrap :email %>
```

## Form Styles

By default, your forms will stack labels on top of controls and your controls
will grow to 100% of the available width.

### Inline Forms

To use an inline-layout form, use the `layout: :inline` option. To hide labels,
use the `hide_label: true` option, which keeps your labels accessible to those
using screen readers.

```erb
<%= bootstrap_form_for(@user, layout: :inline) do |f| %>
  <%= f.email_field :email, hide_label: true %>
  <%= f.password_field :password, hide_label: true %>
  <%= f.check_box :remember_me %>
  <%= f.submit %>
<% end %>
```

### Horizontal Forms

To use a horizontal-layout form with labels to the left of the control, use the
`layout: :horizontal` option. You should specify both `label_col` and
`control_col` css classes as well (they default to `col-sm-2` and `col-sm-10`).

In the example below, the checkbox and submit button have been wrapped in a
`form_group` to keep them properly aligned.

```erb
<%= bootstrap_form_for(@user, layout: :horizontal, label_col: "col-sm-2", control_col: "col-sm-10") do |f| %>
  <%= f.email_field :email %>
  <%= f.password_field :password %>
  <%= f.form_group do %>
    <%= f.check_box :remember_me %>
  <% end %>
  <%= f.form_group do %>
    <%= f.submit %>
  <% end %>
<% end %>
```

The `label_col` and `control_col` css classes can also be changed per control:

```erb
<%= bootstrap_form_for(@user, layout: :horizontal) do |f| %>
  <%= f.email_field :email %>
  <%= f.text_field :age, control_col: "col-sm-3" %>
  <%= f.form_group do %>
    <%= f.submit %>
  <% end %>
<% end %>
```

### Custom Field Layout

The `layout` can be overriden per field:

```erb
<%= bootstrap_form_for(@user, layout: :horizontal) do |f| %>
  <%= f.email_field :email %>
  <%= f.text_field :feet, layout: :default %>
  <%= f.text_field :inches, layout: :default %>
  <%= f.form_group do %>
    <%= f.submit %>
  <% end %>
<% end %>
```

## Validation & Errors

### Inline Errors

By default, fields that have validation errors will outlined in red and the
error will be displayed below the field. Rails normally wraps the fields in a
div (field_with_errors), but this behavior is suppressed. Here's an example:

```html
<div class="form-group has-error">
  <label class="control-label" for="user_email">Email</label>
  <input class="form-control" id="user_email" name="user[email]" type="email" value="">
  <span class="help-block">can't be blank</span>
</div>
```

You can turn off inline errors for the entire form like this:

```erb
<%= bootstrap_form_for(@user, inline_errors: false) do |f| %>
  ...
<% end %>
```

### Alert Messages

To display an error message with an error summary, you can use the
`alert_message` helper. This won't output anything unless a model validation
has failed.

```erb
<%= f.alert_message "Please fix the errors below." %>
```

Which outputs:

```html
<div class="alert alert-danger">
  <p>Please fix the errors below.</p>
  <ul class="rails-bootstrap-forms-error-summary">
    <li>Email can't be blank</li>
  </ul>
</div>
```

You can turn off the error summary like this:

```erb
<%= f.alert_message "Please fix the errors below.", error_summary: false %>
```

To output a simple unordered list of errors, use the `error_summary` helper.

```erb
<%= f.error_summary %>
```

Which outputs:

```html
<ul class="rails-bootstrap-forms-error-summary">
  <li>Email can't be blank</li>
</ul>
```

### Errors On

If you want to display a custom inline error for a specific attribute not
represented by a form field, use the `errors_on` helper.

```erb
<%= f.errors_on :tasks %>
```

Which outputs:

```html
<div class="alert alert-danger">Tasks can't be blank.</div>
```

You can hide the attribute name like this:

```erb
<%= f.errors_on :tasks, hide_attribute_name: true %>
```

Which outputs:

```html
<div class="alert alert-danger">can't be blank.</div>
```

### Hightlight valid fields

For hightlighting valid fields you can use `highlight_valid_fields: true` with bootstrap_form_for for the entire form or for a single field use `highlight_valid: true`.

To enable this feature for all fields in the entire form:
```erb
  <%= bootstrap_form_for(@user, highlight_valid_fields: true) do |f| %>
```

For a single field:
```erb
  <%= f.text_field :name, highlight_valid: true %>
```

This generates, if the field is valid, the following output:
```erb
<div class="form-group has-success">
  <label class="control-label" for="user_name">Name</label>
  <input class="form-control" id="user_name" name="user[name]" value="" type="text">
</div>
```

You can disable this feature for a single field with
```erb
  <%= f.text_field :name, highlight_valid: false %>
```

## Internationalization

bootstrap_form follows standard rails conventions so it's i18n-ready. See more
here: http://guides.rubyonrails.org/i18n.html#translations-for-active-record-models

## Code Triage page

http://www.codetriage.com/potenza/bootstrap_form

## Contributing

We love pull requests! Here's a quick guide for contributing:

1. Fork the repo.

2. Run the existing test suite:

  `$ cd test/dummy && bundle exec rake db:create db:migrate RAILS_ENV=test && cd ../../`
  `$ bundle exec rake`

3. Add tests for your change.

4. Add your changes and make your test(s) pass. Following the conventions you
see used in the source will increase the chance that your pull request is
accepted right away.

5. Update the README if necessary.

6. Add a line to the CHANGELOG for your bug fix or feature.

7. Push to your fork and submit a pull request.

## Contributors

https://github.com/bootstrap-ruby/rails-bootstrap-forms/graphs/contributors

## License

MIT License. Copyright 2012-2014 Stephen Potenza (https://github.com/potenza)
