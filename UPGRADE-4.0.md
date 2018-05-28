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
```
