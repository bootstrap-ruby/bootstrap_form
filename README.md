If you are using Bootstrap v3, refer to the legacy [legacy-2.7](https://github.com/bootstrap-ruby/bootstrap_form/tree/legacy-2.7) branch.

This is a new take on the `bootstrap_form` README. Please leave comments at: #520. You can go back to the traditional [README](/OLD-README.md).

---

# bootstrap_form

[![Build Status](https://travis-ci.org/bootstrap-ruby/bootstrap_form.svg?branch=master)](https://travis-ci.org/bootstrap-ruby/bootstrap_form)
[![Gem Version](https://badge.fury.io/rb/bootstrap_form.svg)](https://rubygems.org/gems/bootstrap_form)

`bootstrap_form` is a Rails form builder that makes it super easy to integrate Bootstrap v4-style forms into your Rails application. It provides form helpers that augment the Rails form helpers. `bootstrap_forms`'s form helpers generate the form field and its label and all the Bootstrap mark-up required for proper Bootstrap display. `bootstrap_form` also provides:

* [Validation error messages](#validation-and-errors) below the field they correspond to, by default. You can also put the error messages after the label, or turn off `bootstrap_form`'s validation error handling and do it yourself.
* Automatic [mark-up for the `required` attribute](#required-fields) on required fields.
* An easy way to consistently show [help](#help-text) text on fields.
* Mark-up for [Bootstrap horizontal forms](#horizontal-forms) (labels to the left of their fields, like a traditional desktop application), if that's what you want.
* Many [options](#form-helpers) to modify or augment the generated mark-up.
* A way to [escape to the Rails form helpers](#accessing-rails-form-helpers) if you need to do something that `bootstrap_form` can't do.

Some other nice things that `bootstrap_form` does for you are:

* Reduces the amount of code in your `.erb` files.
* Gets you going faster with Bootstrap, because you don't need to learn all the rules of Bootstrap form mark-up to get started.
* Reduces errors, because you're doing less typing.
* Makes it easier to see the logic of the form, because it's not mixed in with the Bootstrap mark-up.

`bootstrap_form` works like the standard Rails form helpers, and this README assumes you know how they work. You start a form with one of [`bootstrap_form_with`](#bootstrap-form-with), [`bootstrap_form_for`](#bootstrap-form-for), or [`bootstrap_form_tag`](#bootstrap-form-tag) in a view file. You get a form builder that calls the [`bootstrap_form` helpers](#form-helpers) instead of the standard Rails helpers. You use that form builder in the view file to render one or more form fields.

## Requirements

`bootstrap_form` supports at a minimum the currently supported versions of Ruby and Rails:

* Ruby 2.5+
* Rails 5.2+
* Bootstrap 4.0+

## Installation

Add it to your Gemfile:

```ruby
gem "bootstrap_form", "~> 4.0"
```

Then:

`bundle install`

Depending on which CSS pre-processor you are using, adding the bootstrap form styles differs slightly.
If you use Rails in the default mode without any pre-processor, you'll have to add the following line to your `application.css` file:

```css
*= require rails_bootstrap_forms
```

If you followed the [official bootstrap installation guide](https://github.com/twbs/bootstrap-rubygem#a-ruby-on-rails), you'll probably have switched to SCSS. In this case add the following line to your `application.scss`:

```scss
@import "rails_bootstrap_forms";
```

## Usage

### bootstrap_form_for

To get started, use the `bootstrap_form_for` helper in place of the Rails `form_for` helper. Here's an example:

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

### bootstrap_form_with

Note that `form_with` in Rails 5.1 does not add IDs to form elements and labels by default, which are both important to Bootstrap markup. This behaviour is corrected in Rails 5.2.

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


## Configuration

`bootstrap_form` can be used out-of-the-box without any configuration. However, `bootstrap_form` does have an optional configuration file at `config/initializers/bootstrap_form.rb` for setting options that affect all generated forms in an application.

The current configuration options are:

| Option | Default value | Description |
|---------------------------|------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `default_form_attributes` | `{role: "form"}` | version [2.2.0](https://github.com/bootstrap-ruby/bootstrap_form/blob/master/CHANGELOG.md#220-2014-09-16) added a role="form" attribute to all forms.   The W3C validator will raise a **warning** on forms with a role="form" attribute.   Set this option to `{}` to make forms be W3C compliant. |


Example:
```ruby
# config/initializers/bootstrap_form.rb
BootstrapForm.configure do |c|
  c.default_form_attributes = {} # to make forms W3C compliant
end
```

## Form Helpers

`bootstrap_form` provides its own version of the following Rails form helpers:

```
button                   email_field                               search_field
check_box                file_field                                select
collection_check_boxes   grouped_collection_select                 submit
collection_radio_buttons hidden_field (not wrapped, but supported) telephone_field
collection_select        month_field                               text_area
color_field              number_field                              text_field
date_field               password_field                            time_field
date_select              phone_field                               time_select
datetime_field           radio_button                              time_zone_select
datetime_local_field     range_field                               url_field
datetime_select          rich_text_area (Rails 6+)                 week_field
```

By default, the helpers generate a `label` tag, and an `input`, `select`, or `textarea` tag, by calling the Rails `label` helper, and then the Rails helper with the same name as the `bootstrap_form` helper.

The `bootstrap_form` helpers accept the same options as the standard Rails form helpers, and pass those options through to the Rails helper. They also accept additional options, described in the following section.

## Form Helper Options

Many of the helpers accept the same options. The exceptions are:

[button](#submit-buttons),
[check_box](#checkboxes-and-radios),
[collection_check_boxes](#collections),
[collection_radio_buttons](#collections),
[collection_select](#selects),
[date_select](#date-helpers),
[datetime_select](#date-helpers),
[file_field](#file-fields),
[grouped_collection_select](#selects),
[hidden_field](#hidden-fields),
[radio_button](#checkboxes-and-radios),
[rich_text_area](#rich-text-areas-aka-trix-editor),
[select](#selects),
[submit](#submit-buttons),
[time_select](#date-helpers),
[time_zone_select](#selects)

The options for the form helpers that aren't in the exceptions list are described in the following sub-sections:

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

This generates:

```html
<small class="form-text text-muted">Must be at least 6 characters long</small>
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

If you want to attach multiple items to the input, pass them as an array:

```erb
<%= f.text_field :price, prepend: ['Net', '$'], append: ['.00', 'per day'] %>
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

Bootstrap mark-up dictates that most input field types have the label and input wrapped in a `div.form-group`.

If you want to add an additional CSS class or any other attribute to the form group div, you can use the `wrapper: { class: 'additional-class', data: { foo: 'bar' } }` option.

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

If you only want to set the class on the form group div, you can use the `wrapper_class` option. It's just a short form of `wrapper: { class: 'additional-class' }`.

### Suppressing the Form Group Altogether

You may want to define your own form group div around a field. To do so, add the option `wrapper: false` to the input field. For example:

```ruby
f.form_group :user do
  f.email_field :email, wrapper: false
end
```

Note that Bootstrap relies on the form group div to correctly format most fields, so if you use the `wrapper: false` option, you should provide your own form group div around the input field. You can write your own HTML, or use the `form_group` helper.

## Selects

Our select helper accepts the same arguments as the [default Rails helper](http://api.rubyonrails.org/classes/ActionView/Helpers/FormOptionsHelper.html#method-i-select). Here's an example of how you pass both options and html_options hashes:

```erb
<%= f.select :product, [["Apple", 1], ["Grape", 2]], { label: "Choose your favorite fruit:", wrapper: { class: 'has-warning', data: { foo: 'bar' } } }, { class: "selectpicker" } %>
```

## Checkboxes and Radios

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

### Switches

To render checkboxes as switches with Bootstrap 4.2+, use `custom: :switch`:

```erb
<%= f.check_box :remember_me, custom: :switch %>
```

### Collections

`bootstrap_form` also provides helpers that automatically create the
`form_group` and the `radio_button`s or `check_box`es for you:

```erb
<%= f.collection_radio_buttons :skill_level, Skill.all, :id, :name %>
<%= f.collection_check_boxes :skills, Skill.all, :id, :name %>
```

NOTE: These helpers do not currently support a block, unlike their equivalent Rails helpers. See issue [#477](https://github.com/bootstrap-ruby/bootstrap_form/issues/477). If you need to use the block syntax, use `collection_check_boxes_without_bootstrap` or `collection_radio_buttons_without_bootstrap` for now.

Collection methods accept these options:

* `:label`: Customize the `form_group`'s label
* `:hide_label`: Pass true to hide the `form_group`'s label
* `:help`: Add a help span to the `form_group`
* Other options will be forwarded to the `radio_button`/`check_box` method

## Static Controls

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
<%= f.static_control :field_name, label: "Custom Static Control", value: "Content Here" %>
```

`field_name` may be any name that isn't already used in the form. Note that you may get "unpermitted parameter" messages in your log file with this approach.

You can also create the static control the following way, if you don't need to get the value of the static control as a parameter when the form is submitted:

```erb
<%= f.static_control label: "Custom Static Control", value: "Content Here", name: nil %>
```

(If you neither provide a field name nor `name: nil`, the Rails code that submits the form will give a JavaScript error.)

Prior to version 4 of `bootstrap_form`, you could pass a block to the `static_control` method.
The value of the block would be used for the content of the static "control".
Bootstrap 4 actually creates and styles a disabled input field for static controls, so the value of the control has to be specified by the `value:` option.
Passing a block to `static_control` no longer has any effect.

## Date Helpers

The multiple selects that the date and time helpers (`date_select`,
`time_select`, `datetime_select`) generate are wrapped inside a
`div.rails-bootstrap-forms-[date|time|datetime]-select` tag. This is because
Bootstrap automatically styles our controls as `block`s. This wrapper fixes
this defining these selects as `inline-block` and a width of `auto`.

## Submit Buttons

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

are equivalent, and each of them both be rendered as:

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

## Rich Text Areas AKA Trix Editor

If you're using Rails 6, `bootstrap_form` supports the `rich_text_area` helper.

```erb
<%= f.rich_text_area(:life_story) %>
```

will be rendered as:

```html
<div class="form-group">
  <label for="user_life_story">Life story</label>
  <input type="hidden" name="user[life_story]" id="user_life_story_trix_input_user"/>
  <trix-editor id="user_life_story" data-blob-url-template="http://test.host/rails/active_storage/blobs/:signed_id/:filename" data-direct-upload-url="http://test.host/rails/active_storage/direct_uploads" input="user_life_story_trix_input_user" class="trix-content form-control"/>
  </trix-editor>
</div>
```

## File Fields

The `file_field` helper generates mark-up for a Bootstrap 4 custom file field entry. It takes the [options for `text_field`](#form-helper-options), minus `append` and `prepend`.

## Hidden Fields

The `hidden_field` helper in `bootstrap_form` calls the Rails helper directly, and does no additional mark-up.

## Accessing Rails Form Helpers

If you want to use the original Rails form helpers for a particular field,
append `_without_bootstrap` to the helper:

```erb
<%= f.text_field_without_bootstrap :email %>
```

## Form Styles

By default, your forms will stack labels on top of controls and your controls
will grow to 100 percent of the available width. This is consistent with Bootstrap's "mobile first" approach.

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

or default value can be changed in initializer:

```ruby
# config/initializers/bootstrap_form.rb
module BootstrapForm
  class FormBuilder
    def default_label_col
      'col-sm-4'
    end
    def default_control_col
      'col-sm-8'
    end
    def default_layout
      # :default, :horizontal or :inline
      :horizontal
    end
  end
end
```

Control col wrapper class can be modified with `add_control_col_class`. This option will preserve column definition:

```erb
<%= bootstrap_form_for(@user, layout: :horizontal) do |f| %>
  <%= f.email_field :email %>
  <%= f.text_field :age, add_control_col_class: "additional-control-col-class" %>
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

Rails normally wraps fields with validation errors in a `div.field_with_errors`, but this behaviour isn't consistent with Bootstrap 4 styling. By default, `bootstrap_form` generations in-line errors which appear below the field. But it can also generate errors on the label, or not display any errors, leaving it up to you.

### Inline Errors

By default, fields that have validation errors will be outlined in red and the
error will be displayed below the field. Here's an example:

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

```erb
<%= bootstrap_form_for(@user, label_errors: true) do |f| %>
  ...
<% end %>
```

By default, turning on `:label_errors` will also turn off
`:inline_errors`. If you want both turned on, you can do that too:

```erb
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

## Required Fields

A label that is associated with a required field is automatically annotated with
a `required` CSS class. `bootstrap_form` doesn't provide any styling for required fields. You're free to add any appropriate CSS to style
required fields as desired. One example would be to automatically add an
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

In cases where this behaviour is undesirable, use the `required` option to force the class to be present or absent:

```erb
<%= f.password_field :login, label: "New Username", required: true %>
<%= f.password_field :password, label: "New Password", required: false %>
```

## Internationalization

bootstrap_form follows standard rails conventions so it's i18n-ready. See more
here: http://guides.rubyonrails.org/i18n.html#translations-for-active-record-models

## Future Compatibility

The Rails team has [suggested](https://github.com/rails/rails/issues/25197) that `form_for` and `form_tag` may be deprecated and then removed in future versions of Rails. `bootstrap_form` will continue to support `bootstrap_form_for` and `bootstrap_form_tag` as long as Rails supports `form_for` and `form_tag`.

## Other Tips and Edge Cases

By their very nature, forms are extremely diverse. It would be extremely difficult to provide a gem that could handle every need. Here are some tips for handling edge cases.

### Empty But Visible Labels

Some third party plug-ins require an empty but visible label on an input control. The `hide_label` option generates a label that won't appear on the screen, but it's considered invisible and therefore doesn't work with such a plug-in. An empty label (e.g. `""`) causes the underlying Rails helper to generate a label based on the field's attribute's name.

The solution is to use a zero-width character for the label, or some other "empty" HTML. For example:

```ruby
label: "&#8203;".html_safe
```

or

```ruby
label: "<span></span>".html_safe
```

## Contributing

We welcome contributions.
If you're considering contributing to bootstrap_form,
please review the [Contributing](/CONTRIBUTING.md)
document first.

## License

MIT License. Copyright 2012-2020 Stephen Potenza (https://github.com/potenza) and others
