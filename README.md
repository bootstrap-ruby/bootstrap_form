[![Build Status](https://travis-ci.org/potenza/bootstrap_form.png)](https://travis-ci.org/potenza/bootstrap_form)

# BootstrapForm

**BootstrapForm** is a form builder that makes it super easy to
integrate Twitter Bootstrap-style forms into your Rails App.

## Requirements

* Ruby 1.9+
* Rails 3, 4
* Twitter Bootstrap 3.0+

## Installation

Add it to your Gemfile:

`gem 'bootstrap_form'`

Then:

`bundle`

### Rails 3

Add this line to app/assets/stylesheets/application.css.scss:

```css
/*
 *= require bootstrap_form
*/
```

## Usage

To get started, just use the **BootstrapForm** form helper. Here's an example:

```erb
<%= bootstrap_form_for(@user) do |f| %>
  <%= f.text_field :name %>
  <%= f.email_field :email %>
  <%= f.password_field :password %>
  <%= f.submit "Create My Account" %>
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

### Default Form Style

By default, your forms will stack labels on top of controls and your controls
will grow to 100% of the available width.

### Inline Forms

To use a inline-style form, use the `style: :inline` option. To hide labels, use
the `sr-only` class, which keeps your forms accessible for those using Screen
Readers.

```erb
<%= bootstrap_form_for(@user, style: :inline) do |f| %>
  <%= f.email_field :email, label_class: "sr-only" %>
  <%= f.password_field :password, label_class: "sr-only" %>
  <%= f.check_box :terms, label: "Remember Me" %>
  <%= f.submit "Create My Account" %>
<% end %>
```

### Horizontal Forms

To use a horizontal-style form with labels to the left of the inputs,
use the `style: :horizontal` option. You will need to specify both label and
control widths.

```erb
<%= bootstrap_form_for(@user, style: horizontal) do |f| %>
  <%= f.email_field :email, label_class: "col-sm-2", wrap_control: "col-sm-10" %>
  <%= f.password_field :password, label_class: "col-sm-2", wrap_control: "col-sm-10" %>

  <%= f.form_group nil, wrap_content: "col-sm-offset-2 col-sm-10" do %>
    <%= f.submit "Create My Account" %>
  <% end %>
<% end %>
```

<!--

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

If you don't want to render the field's label, pass `:none` to the option:

```erb
<%= f.text_area :comment, label: :none, placeholder: 'Leave a comment...' %>
```

With check boxes you can define your labels using a block too:

```erb
<%= f.check_box :terms do %>
You need to check this box to accept our terms of service and privacy policy
<% end %>
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
<%= f.text_field :amount, append: '.00' %>
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
-->

## Code Triage page

http://www.codetriage.com/potenza/bootstrap_form

## Contributors

https://github.com/potenza/bootstrap_form/graphs/contributors

## License

MIT License. Copyright 2012-2013 Stephen Potenza (https://github.com/potenza)
