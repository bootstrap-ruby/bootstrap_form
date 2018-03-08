# Upgrading to `bootstrap_form` 4.0
We made every effort to make the upgrade from `bootstrap_form` v2.7 (Bootstrap 3) to `bootstrap_form` v4.0 (Bootstrap 4) as easy as possible. However, Bootstrap 4 is fundamentally different from Bootstrap 3, so some changes may be necessary in your code.

## Bootstrap 4 Changes
If you made use of Bootstrap classes or Javascript, you should read the [Bootstrap 4 migration guide](https://getbootstrap.com/docs/4.0/migration/).

## Validation Error Messages
With Bootstrap 4, in order for validation error messages to display, the message has to be a sibling of the `input` tag, and the `input` tag has to have the `.is-invalid` class. This was different from Bootstrap 3, and forced some changes to `bootstrap_form` that may affect programs that used `bootstrap_form` v2.7.

### Arbitrary Text in `form_group` Blocks
In `bootstrap_form` v2.7, it was possible to write something like this:
```
<%= bootstrap_form_for(@user) do |f| %>
  <%= f.form_group(:email) do %>
    <p class="form-control-static">Bar</p>
  <%= end %>
<%= end %>
```
and, if `@user.email` had validation errors, it would render:
```
<div class="form-group has-error">
  <p class="form-control-static">Bar</p>
  <span class="help-block">can't be blank, is too short (minimum is 5 characters)</span>
</div>
```
which would show an error message in red.

That doesn't work in Bootstrap 4. Outputting error messages had to be moved to accommodate other changes, so `form_group` no longer outputs error messages unless whatever is inside the block is a `bootstrap_form` helper.

One way to make the above behave the same in `bootstrap_form` v4.0 is to write it like this:

```
<%= bootstrap_form_for(@user) do |f| %>
  <%= f.form_group(:email) do %>
    <p class="form-control-plaintext">Bar</p>
    <%= content_tag(:div, @user.errors[:email].join(", "), class: "invalid-feedback", style: "display: block;") unless @user.errors[:email].empty? %>
  <%= end %>
<%= end %>
```

### Check Boxes and Radio Buttons
Bootstrap 4 marks up check boxes and radio buttons differently. In particular, Bootstrap 4 wraps the `input` and `label` tags in a `div.form-check` tag. Because validation error messages have to be siblings of the `input` tag, there is now an `error_message` option to `check_box` and `radio_button` to cause them to put the validation error messages inside the `div.form-check`.

This change is mostly invisible to existing programs:

- Since the default for `error_message` is false, use of `check_box` and `radio_button` all by themselves behaves the same as in `bootstrap_form` v2.7
- All the `collection*` helpers that output radio buttons and check boxes arrange to produce the validation error message on the last check box or radio button of the group, like `bootstrap_form` v2.7 did

There is one situation where an existing program will have to change. When rendering one or more check boxes or radio buttons inside a `form_group` block, the last call to `check_box` or `radio_button` in the block will have to have `error_message: true` added to its parameters, like this:

```
<%= bootstrap_form_for(@user) do |f| %>
  <%= f.form_group(:education) do %>
    <%= f.radio_button(:misc, "primary school") %>
    <%= f.radio_button(:misc, "high school") %>
    <%= f.radio_button(:misc, "university", error_message: true) %>
  <%= end %>
<%= end %>
```

## `form-group` and Horizontal Forms
In Bootstrap 3, `.form-group` mixed in `.row`. In Bootstrap 4, it doesn't. So `bootstrap_form` automatically adds `.row` to the `div.form-group`s that it creates, if the form group is in a horizontal layout. When migrating forms from the Bootstrap 3 version of `bootstrap_form` to the Bootstrap 4 version, check all horizontal forms to be sure they're being rendered properly.

Bootstrap 4 also provides a `.form-row`, which has smaller gutters than `.row`. If you specify ".form-row", `bootstrap_form` will replace `.row` with `.form-row` on the `div.form-group`. When calling `form_group` directly, do something like this:
```
bootstrap_form_for(@user, layout: "horizontal") do |f|
  f.form_group class: "form-row" do
    ...
  end
end
```
For the other helpers, do something like this:
```
bootstrap_form_for(@user, layout: "horizontal") do |f|
  f.form_group class: "form-row" do
  f.text_field wrapper_class: "form-row" # or f.text_field wrapper: { class: "form-row" }
    ...
  end
end
