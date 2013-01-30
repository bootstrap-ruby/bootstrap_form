# BootstrapForm

**BootstrapForm** is a form builder that makes it super easy to
integrate Twitter Bootstrap-style forms into your Rails App.

## Requirements

* Ruby 1.9+
* Rails 3.1+
* Twitter Bootstrap 2.0+

## Installation

Add it to your Gemfile:

`gem 'bootstrap_form'`

Run the following command to install it:

`bundle`

Add this line to app/assets/stylesheets/application.css.scss:

```css
/*
 *= require bootstrap_form
*/
```

## Example

Here's a quick example to get you started:

```erb
<%= bootstrap_form_for(@user, html: { class: 'form-horizontal' }, help: :block) do |f| %>
  <%= f.alert_message "Please fix the errors below." %>

  <%= f.text_field :twitter_username, prepend: '@', label: 'Twitter' %>
  <%= f.text_field :email %>
  <%= f.password_field :password, help: 'Must be at least 6 characters long' %>
  <%= f.password_field :password_confirmation, label: 'Confirm Password' %>
  <%= f.control_group :terms do %>
    <%= f.check_box :terms, label: 'I agree to the Terms of Service' %>
  <% end %>

  <%= f.actions do %>
    <%= f.primary 'Create My Account', disable_with: 'Saving...' %>
  <% end %>
<% end %>
```

Screenshot:

![Example form](https://github.com/potenza/bootstrap_form/raw/master/examples/example_form.png)

Screenshot with errors:

![Example form with errors](https://github.com/potenza/bootstrap_form/raw/master/examples/example_form_errors.png)
    
## Usage

To get started, just use the **BootstrapForm** form helper:

```erb
<%= bootstrap_form_for(@user) do |f| %>
  ...
<% end %>
```

To use a horizontal-style form with labels to the left of the inputs,
add the `.form-horizontal` class:

```erb
<%= bootstrap_form_for(@user, html: { class: 'form-horizontal' }) do |f| %>
  ...
<% end %>
```

### Form Helpers

This gem wraps the following Rails form helpers:

* text_field
* password_field
* text_area
* file_field
* number_field
* email_field
* telephone_field / phone_field
* url_field
* select
* collection_select
* date_select
* time_select
* datetime_select
* check_box
* radio_button

You can use the helpers like you're used to:

```erb
<%= bootstrap_form_for(@user) do |f| %>
  <%= f.text_field :email %>
  <%= f.password_field :password %>
  <%= f.primary "Create My Account" %>
<% end %>
```

This gem also wraps checkboxes and radios, which should be placed inside
of a `control_group` to render correctly. The following example ensures
that the entire control group will display an error if an associated 
validations fails:

```erb
<%= f.control_group :skill_level, label: { text: 'Skill' }, help: 'This is optional' do %>
  <%= f.radio_button :skill_level, 0, label: 'Novice', checked: true %>
  <%= f.radio_button :skill_level, 1, label: 'Intermediate' %>
  <%= f.radio_button :skill_level, 2, label: 'Advanced' %>
<% end %>

<%= f.control_group :terms, label: { text: 'Terms' } do %>
  <%= f.check_box :terms, label: 'I agree to the Terms of Service' %>
<% end %>
```

You can display checkboxes and radios `inline` like this:

```erb
<%= f.control_group :skill_level, label: { text: 'Skill' } do %>
  <%= f.radio_button :skill_level, 0, label: 'Novice', inline: true %>
  <%= f.radio_button :skill_level, 1, label: 'Intermediate', inline: true %>
  <%= f.radio_button :skill_level, 2, label: 'Advanced', inline: true %>
<% end %>
```

### Labels

Use the `label` option if you want to specify the field's label text:

```erb
<%= f.password_field :password_confirmation, label: 'Confirm Password' %>
```

NOTE: To specify the label for a `control_group` you must do it like this:

```erb
<%= f.control_group :terms, label: { text: 'Terms' } do %>
  <%= f.check_box :terms, label: 'I agree to the Terms of Service' %>
<% end %>
```

### Help text

To add help text, use the `help` option, which will place it
to the right of the field:

```erb
<%= f.password_field :password, help: 'Must be at least 6 characters long' %>
```

To place help text underneath a field, pass the option `help:
:block` to the `bootstrap_form_for` helper:

```erb
<%= bootstrap_form_for(@user, help: :block) do |f| %>
  <%= f.password_field :password, help: 'Must be at least 6 characters long' %>
<% end %>
```

### Prepending inputs

You can prepend an input file with the `prepend` option:

```erb
<%= f.text_field :twitter_username, prepend: '@' %>
```

### Appending inputs

You can append an input file with the `append` option:

```erb
<%= f.text_field :amount, append: '.00 %>
```

### Submit buttons

This gem provides a few different options for submit buttons.

Here's a simple `primary` button (this applies the `.btn` and `.btn-primary` classes):

```erb
<%= f.primary "Create My Account" %>
```

Here's a `secondary` submit button (applies just the `.btn` class):

```erb
<%= f.secondary "Create My Account" %>
```

You can use the `actions` helper, which wraps your submit button in a
`.form-actions` class.

```erb
<%= f.actions do %>
  <%= f.primary 'Create My Account' %>
<% end %>
```

And if you don't want to use the `actions` helper, here's how you might 
style a `primary` button with horizontal-style forms:

```erb
<%= bootstrap_form_for(@user, html: { class: 'form-horizontal' }) do |f| %>
  <%= f.control_group do %>
    <%= f.primary "Create My Account" %>
  <% end %>
<% end %>
```

### Custom Control Groups

Sometimes you need to wrap an element in Bootstrap-style markup.
This is mostly needed to align submit buttons when using horizontal-style
forms (also shown above):

```erb
<%= bootstrap_form_for(@user, html: { class: 'form-horizontal' }) do |f| %>
  <%= f.control_group do %>
    <%= f.primary "Create My Account" %>
  <% end %>
<% end %>
```

To specify a label that isn't linked to an element you can do this:

```erb
<%= f.control_group :nil, label: { text: 'Foo' } do %>
  <span>Bar</span>
<% end %>
```

### Validation Errors

When a validation error is triggered, the field will be outlined and the
error will be displayed next to the field (or below it if you're using
block-style help text). Rails normally wraps fields in a div
(field_with_errors), but this behavior is suppressed when
`bootstrap_form_for` is called.

To display an error message wrapped in `.alert` and `.alert-error`
classes, you can use the `alert_message` helper:

```erb
  <%= f.alert_message "Please fix the errors below." %>
```

## Contributors

https://github.com/potenza/bootstrap_form/graphs/contributors

## License

MIT License. Copyright 2012-2013 Stephen Potenza (https://github.com/potenza)
