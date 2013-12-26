[![Build Status](https://travis-ci.org/potenza/bootstrap_form.png?branch=master)](https://travis-ci.org/potenza/bootstrap_form) [![Code Climate](https://codeclimate.com/github/potenza/bootstrap_form.png)](https://codeclimate.com/github/potenza/bootstrap_form)

# BootstrapForm

**BootstrapForm** is a rails form builder that makes it super easy to integrate
twitter bootstrap-style forms into your rails application.

## Requirements

* Ruby 1.9+
* Rails 3+
* Twitter Bootstrap 3.0+

## Installation

Add it to your Gemfile:

`gem 'bootstrap_form'`

Then:

`bundle`

## Usage

To get started, just use the **BootstrapForm** form helper. Here's an example:

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

### Supported Form Helpers

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

To use an inline-style form, use the `style: :inline` option. To hide labels,
use the `hide_label: true` option, which keeps your labels accessible to those
using screen readers.

```erb
<%= bootstrap_form_for(@user, style: :inline) do |f| %>
  <%= f.email_field :email, hide_label: true %>
  <%= f.password_field :password, hide_label: true %>
  <%= f.check_box :remember_me %>
  <%= f.submit %>
<% end %>
```

### Horizontal Forms

To use a horizontal-style form with labels to the left of the inputs, use the
`style: :horizontal` option. You should specify both `left` and `right` css
classes as well (they default to `col-sm-2` and `col-sm-10`).

In the example below, the checkbox and submit button have been wrapped in a
`form_group` to keep them properly aligned.

```erb
<%= bootstrap_form_for(@user, style: :horizontal, left: "col-sm-2", right: "col-sm-10") do |f| %>
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

### Submit Buttons

The `btn btn-default` css classes are automatically added to your submit
buttons.

```erb
<%= f.submit %>
```

You can also use the `primary` helper, which adds `btn btn-primary` to your
submit button:

```erb
<%= f.primary "Optional Label" %>
```

You can specify your own classes like this:

```erb
<%= f.submit "Log In", class: "btn btn-success" %>
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

### Prepending and Appending Inputs

You can pass `prepend` and/or `append` options to input fields:

```erb
<%= f.text_field :price, prepend: "$", append: ".00" %>
```

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
<%= f.static_control nil, label: "Custom Static Control" do %>
  Content Here
<% end %>
```

### Validation Errors

When a validation error is triggered, the field will be outlined and the error
will be displayed below the field. Rails normally wraps the fields in a div
(field_with_errors), but this behavior is suppressed.

To display an error message wrapped in `.alert` and `.alert-danger`
classes, you can use the `alert_message` helper:

```erb
<%= f.alert_message "Please fix the errors below." %>
```

### Internationalization

bootstrap_form follows standard rails conventions so it's i18n-ready. See more
here: http://guides.rubyonrails.org/i18n.html#translations-for-active-record-models

## Code Triage page

http://www.codetriage.com/potenza/bootstrap_form

## Contributors

https://github.com/potenza/bootstrap_form/graphs/contributors

## License

MIT License. Copyright 2012-2013 Stephen Potenza (https://github.com/potenza)
