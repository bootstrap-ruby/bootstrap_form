⚠️ **This documentation is for the master branch, which is not yet stable and targets Bootstrap v4.** If you are using Bootstrap v3, refer to the stable [legacy-2.7](https://github.com/bootstrap-ruby/bootstrap_form/tree/legacy-2.7) branch.

---

# bootstrap_form

[![Build Status](https://travis-ci.org/bootstrap-ruby/bootstrap_form.svg?branch=master)](https://travis-ci.org/bootstrap-ruby/bootstrap_form)
[![Gem Version](https://badge.fury.io/rb/bootstrap_form.svg)](https://rubygems.org/gems/bootstrap_form)

**bootstrap_form** is a Rails form builder that makes it super easy to integrate
Bootstrap v4-style forms into your Rails application.

## Requirements

* Ruby 2.2.2+
* Rails 5.0+ (Rails 5.1+ for `bootstrap_form_with`)
* Bootstrap 4.0.0+

## Installation

Add it to your Gemfile:

```ruby
gem "bootstrap_form", ">= 4.0.0.alpha1"
```

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
  <%= f.submit "Log In" %>
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
  <div class="form-check">
    <input name="user[remember_me]" type="hidden" value="0">
    <input class="form-check-input" id="user_remember_me" name="user[remember_me]" type="checkbox" value="1">
    <label class="form-check-label" for="user_remember_me">Remember me</label>
  </div>
  <input class="btn btn-secondary" name="commit" type="submit" value="Log In">
</form>
```

### bootstrap_form_tag

If your form is not backed by a model, use the `bootstrap_form_tag`. Usage of this helper is the same as `bootstrap_form_for`, except no model object is passed in as the first argument. Here's an example:

```erb
<%= bootstrap_form_tag url: '/subscribe' do |f| %>
  <%= f.email_field :email, value: 'name@example.com' %>
  <%= f.submit %>
<% end %>
```

### `bootstrap_form_with` (Rails 5.1+)

Note that `form_with` in Rails 5.1 does not add IDs to form elements and labels by default, which are both important to Bootstrap markup. This behavior is corrected in Rails 5.2.

To get started, just use the `bootstrap_form_with` helper in place of `form_with`. Here's an example:

```erb
<%= bootstrap_form_with(model: @user, local: true) do |f| %>
  <%= f.email_field :email %>
  <%= f.password_field :password %>
  <%= f.check_box :remember_me %>
  <%= f.submit "Log In" %>
<% end %>
```

This generates:

```html
<form role="form" action="/users" accept-charset="UTF-8" method="post">
  <input name="utf8" type="hidden" value="&#x2713;" />
  <div class="form-group">
    <label class="required" for="user_email">Email</label>
    <input class="form-control" type="email" value="steve@example.com" name="user[email]" />
  </div>
  <div class="form-group">
    <label for="user_password">Password</label>
    <input class="form-control" type="password" name="user[password]" />
    <small class="form-text text-muted">A good password should be at least six characters long</small>
  </div>
  <div class="form-check">
    <input name="user[remember_me]" type="hidden" value="0">
    <input class="form-check-input" id="user_remember_me" name="user[remember_me]" type="checkbox" value="1">
    <label class="form-check-label" for="user_remember_me">Remember me</label>
  </div>
  <input type="submit" name="commit" value="Log In" class="btn btn-secondary" data-disable-with="Log In" />
</form>
```

`bootstrap_form_with` supports both the `model:` and `url:` use cases
in `form_with`.

`form_with` has some important differences compared to `form_for` and `form_tag`, and these differences apply to `bootstrap_form_with`. A good summary of the differences can be found at: https://m.patrikonrails.com/rails-5-1s-form-with-vs-old-form-helpers-3a5f72a8c78a, or in the [Rails documentation](api.rubyonrails.org).

### Future Compatibility

The Rails team has [suggested](https://github.com/rails/rails/issues/25197) that `form_for` and `form_tag` may be deprecated and then removed in future versions of Rails. `bootstrap_form` will continue to support `bootstrap_form_for` and `bootstrap_form_tag` as long as Rails supports `form_for` and `form_tag`.

## Form Helpers

This gem wraps the following Rails form helpers:

* check_box
* collection_check_boxes
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
* collection_radio_buttons
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
* submit
* button

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
<%= f.text_area :comment, hide_label: true, placeholder: "Leave a comment..." %>
```

To add custom classes to the field's label:

```erb
<%= f.text_field :email, label_class: "custom-class" %>
```

Or you can add the label as input placeholder instead (this automatically hides the label):

```erb
<%= f.text_field :email, label_as_placeholder: true %>
```

#### Required Fields

A label that is associated with a required field is automatically annotated with
a `required` CSS class. You are free to add any appropriate CSS to style
required fields as desired.  One example would be to automatically add an
asterisk to the end of the label:

```css
label.required:after {
  content:" *";
}
```

The label `required` class is determined based on the definition of a presence
validator with the associated model attribute. Presently this is one of:
ActiveRecord::Validations::PresenceValidator or
ActiveModel::Validations::PresenceValidator.

In cases where this behavior is undesirable, use the `skip_required` option:

```erb
<%= f.password_field :password, label: "New Password", skip_required: true %>
```

### Input Elements / Controls

To specify the class of the generated input tag, use the `control_class` option:

```erb
<%= f.text_field :email, control_class: "custom-class" %>
```

### Help Text

To add help text, use the `help` option:

```erb
<%= f.password_field :password, help: "Must be at least 6 characters long" %>
```

This gem is also aware of help messages in locale translation files (i18n):

```yml
en:
  activerecord:
    help:
      user:
        password: "A good password should be at least six characters long"
```

Help translations containing HTML should follow the convention of appending `_html` to the name:

```yml
en:
  activerecord:
    help:
      user:
        password_html: "A <strong>good</strong> password should be at least six characters long"
```

If your model name has multiple words (like `SuperUser`), the key on the
translation file should be underscored (`super_user`).

You can override help translations for a particular field by passing the `help`
option or turn them off completely by passing `help: false`.

### Prepending and Appending Inputs

You can pass `prepend` and/or `append` options to input fields:

```erb
<%= f.text_field :price, prepend: "$", append: ".00" %>
```

You can also prepend and append buttons. Note: The buttons must contain the
`btn` class to generate the correct markup.

```erb
<%= f.text_field :search, append: link_to("Go", "#", class: "btn btn-secondary") %>
```

To add a class to the input group wrapper, use the `:input_group_class` option.

```erb
<%= f.email_field :email, append: f.primary('Subscribe'), input_group_class: 'input-group-lg' %>
```

### Additional Form Group Attributes

If you want to add an additional css class or any other attribute to the form group div, you can use
the `wrapper: { class: 'additional-class', data: { foo: 'bar' } }` option.

```erb
<%= f.text_field :name, wrapper: { class: 'has-warning', data: { foo: 'bar' } } %>
```

Which produces the following output:

```erb
<div class="form-group has-warning" data-foo="bar">
  <label class="form-control-label" for="user_name">Id</label>
  <input class="form-control" id="user_name" name="user[name]" type="text">
</div>
```

You still can use `wrapper_class` option to set only a css class. This is just a short form of `wrapper: { class: 'additional-class' }`.

### Selects

Our select helper accepts the same arguments as the [default Rails helper](http://api.rubyonrails.org/classes/ActionView/Helpers/FormOptionsHelper.html#method-i-select). Here's an example of how you pass both options and html_options hashes:

```erb
<%= f.select :product, [["Apple", 1], ["Grape", 2]], { label: "Choose your favorite fruit:" }, { class: "selectpicker",  wrapper: { class: 'has-warning', data: { foo: 'bar' } } } %>
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

Check boxes and radio buttons are wrapped in a `div.form-check`. You can add classes to this `div` with the `:wrapper_class` option:

```erb
<%= f.radio_button :skill_level, 0, label: "Novice", inline: true, wrapper_class: "w-auto" %>
```

#### Collections

`bootstrap_form` also provides helpers that automatically create the
`form_group` and the `radio_button`s or `check_box`es for you:

```erb
<%= f.collection_radio_buttons :skill_level, Skill.all, :id, :name %>
<%= f.collection_check_boxes :skills, Skill.all, :id, :name %>
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

Here's the output for a horizontal layout:

```html
<div class="form-group">
  <label class="col-sm-2 form-control-label" for="user_email">Email</label>
  <div class="col-sm-10">
    <input class="form-control-plaintext" id="user_email" name="user[email]" readonly="readonly" type="text" value="test@email.com"/>
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
Bootstrap automatically styles our controls as `block`s. This wrapper fixes
this defining these selects as `inline-block` and a width of `auto`.

### Submit Buttons

The `btn btn-secondary` CSS classes are automatically added to your submit
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

If the `primary` helper receives a `render_as_button: true` option or a block,
it will be rendered as an HTML button, instead of an input tag. This allows you
to specify HTML content and styling for your buttons (such as adding
illustrative icons to them). For example, the following statements

```erb
<%= f.primary "Save changes <span class='fa fa-save'></span>".html_safe, render_as_button: true %>

<%= f.primary do
      concat 'Save changes '
      concat content_tag(:span, nil, class: 'fa fa-save')
    end %>
```

are equivalent, and each of them both be rendered as

```html
<button name="button" type="submit" class="btn btn-primary">Save changes <span class="fa fa-save"></span></button>
```

If you wish to add additional CSS classes to your button, while keeping the
default ones, you can use the `extra_class` option. This is particularly useful
for adding extra details to buttons (without forcing you to repeat the
Bootstrap classes), or for element targeting via CSS classes.
Be aware, however, that using the `class` option will discard any extra classes
you add. As an example, the following button declarations

```erb
<%= f.primary "My Nice Button", extra_class: 'my-button' %>

<%= f.primary "My Button", class: 'my-button' %>
```

will be rendered as

```html
<input type="submit" value="My Nice Button" class="btn btn-primary my-button" />

<input type="submit" value="My Button" class="my-button" />
```

(some unimportant HTML attributes have been removed for simplicity)

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

To skip label rendering at all, use `skip_label: true` option.

```erb
<%= f.password_field :password, skip_label: true %>
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

The form-level `layout` can be overridden per field, unless the form-level layout was `inline`:

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

A form-level `layout: :inline` can't be overridden because of the way Bootstrap 4 implements in-line layouts. One possible work-around is to leave the form-level layout as default, and specify the individual fields as `layout: :inline`, except for the fields(s) that should be other than in-line.

### Custom Form Element Styles

The `custom` option can be used to replace the browser default styles for check boxes and radio buttons with dedicated Bootstrap styled form elements. Here's an example:

```erb
<%= bootstrap_form_for(@user) do |f| %>
  <%= f.email_field :email %>
  <%= f.password_field :password %>
  <%= f.check_box :remember_me, custom: true %>
  <%= f.submit "Log In" %>
<% end %>
```

## Validation and Errors

### Inline Errors

By default, fields that have validation errors will be outlined in red and the
error will be displayed below the field. Rails normally wraps the fields in a
div (field_with_errors), but this behavior is suppressed. Here's an example:

```html
<div class="form-group">
  <label class="form-control-label" for="user_email">Email</label>
  <input class="form-control is-invalid" id="user_email" name="user[email]" type="email" value="">
  <small class="invalid-feedback">can't be blank</small>
</div>
```

You can turn off inline errors for the entire form like this:

```erb
<%= bootstrap_form_for(@user, inline_errors: false) do |f| %>
  ...
<% end %>
```

### Label Errors

You can also display validation errors in the field's label; just turn
on the `:label_errors` option. Here's an example:

```
<%= bootstrap_form_for(@user, label_errors: true) do |f| %>
  ...
<% end %>
```

By default, turning on `:label_errors` will also turn off
`:inline_errors`. If you want both turned on, you can do that too:

```
<%= bootstrap_form_for(@user, label_errors: true, inline_errors: true) do |f| %>
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

## Internationalization

bootstrap_form follows standard rails conventions so it's i18n-ready. See more
here: http://guides.rubyonrails.org/i18n.html#translations-for-active-record-models

## Other Tips and Edge Cases
By their very nature, forms are extremely diverse. It would be extremely difficult to provide a gem that could handle every need. Here are some tips for handling edge cases.

### Empty But Visible Labels
Some third party plug-ins require an empty but visible label on an input control. The `hide_label` option generates a label that won't appear on the screen, but it's considered invisible and therefore doesn't work with such a plug-in. An empty label (e.g. `""`) causes the underlying Rails helper to generate a label based on the field's attribute's name.

The solution is to use a zero-width character for the label, or some other "empty" HTML. For example:
```
label: "&#8203;".html_safe
```
or
```
label: "<span></span>".html_safe
```

## Code Triage page

http://www.codetriage.com/potenza/bootstrap_form

## Contributing

We welcome contributions.
If you're considering contributing to bootstrap_form,
please review the [Contributing](/CONTRIBUTING.md)
document first.

## License

MIT License. Copyright 2012-2018 Stephen Potenza (https://github.com/potenza)
