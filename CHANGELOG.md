## [Pending Release][]

### Breaking changes

* Your contribution here!

### New features

* [#476] Give a way to pass classes to the `div.form-check` wrapper for check boxes and radio buttons - [@lcreid](https://github.com/lcreid).
* [461](https://github.com/bootstrap-ruby/bootstrap_form/pull/461): default form-inline class applied to parent content div on date select helpers. Can override with a :skip_inline option on the field helper - [@lancecarlson](https://github.com/lancecarlson).
* Your contribution here!
* The `button`, `submit`, and `primary` helpers can now receive an additional option, `extra_class`. This option allows us to specify additional CSS classes to be added to the corresponding button/input, _while_ maintaining the original default ones. E.g., a primary button with an `extra_class` 'test-button' will have its final CSS classes declaration as 'btn btn-primary test-button'.

### Bugfixes

* Your contribution here!
* [#347](https://github.com/bootstrap-ruby/bootstrap_form/issues/347) Fix `wrapper_class` and `wrapper` options for helpers that have `html_options`.
* [#472](https://github.com/bootstrap-ruby/bootstrap_form/pull/472) Use `id` option value as `for` attribute of label for custom checkboxes and radio buttons.
* [#478](https://github.com/bootstrap-ruby/bootstrap_form/issues/478) Fix offset for form group without label when multiple label widths are specified.


## [4.0.0.alpha1][] (2018-06-16)

🚨 **This release adds support for Bootstrap v4 and drops support for Bootstrap v3.** 🚨

If your app uses Bootstrap v3, you should continue using bootstrap_form 2.7.x instead.

Bootstrap v3 and v4 are very different, and thus bootstrap_form now produces different markup in order to target v4. The changes are too many to list here; you can refer to Bootstrap's [Migrating to v4](https://getbootstrap.com/docs/4.0/migration/) page for a detailed explanation.

In addition to these necessary markup changes, the bootstrap_form API itself has the following important changes in this release.

### Breaking changes

* Rails 4.x is no longer supported
* Ruby 2.2 or newer is required
* Built-in support for the `nested_form` gem has been completely removed
* The `icon` option is no longer supported (Bootstrap v4 does not include icons)
* The deprecated Rails methods `check_boxes_collection` and `radio_buttons_collection` have been removed
* `hide_label: true` and `skip_label: true` on individual check boxes and radio buttons apply Bootstrap 4 markup. This means the appearance of a page may change if you're upgrading from the Bootstrap 3 version of `bootstrap_form`, and you used `check_box` or `radio_button` with either of those options
* `static_control` will no longer properly show error messages. This is the result of bootstrap changes.
* `static_control` will also no longer accept a block, use the `value` option instead.
* `form_group` with a block that produces arbitrary text needs to be modified to produce validation error messages (see the UPGRADE-4.0 document). [@lcreid](https://github.com/lcreid).
* `form_group` with a block that contains more than one `check_box` or `radio_button` needs to be modified to produce validation error messages (see the UPGRADE-4.0 document). [@lcreid](https://github.com/lcreid).
* [#456](https://github.com/bootstrap-ruby/bootstrap_form/pull/456): Fix label `for` attribute when passing non-english characters using `collection_check_boxes` - [@ug0](https://github.com/ug0).
* [#449](https://github.com/bootstrap-ruby/bootstrap_form/pull/449): Bootstrap 4 no longer mixes in `.row` in `.form-group`. `bootstrap_form` adds `.row` to `div.form-group` when layout is horizontal.

### New features

* Support for Rails 5.1 `form_with` - [@lcreid](https://github.com/lcreid).
* Support Bootstrap v4's [Custom Checkboxes and Radios](https://getbootstrap.com/docs/4.0/components/forms/#checkboxes-and-radios-1) with a new `custom: true` option
* Allow HTML in help translations by using the `_html` suffix on the key - [@unikitty37](https://github.com/unikitty37)
* [#408](https://github.com/bootstrap-ruby/bootstrap_form/pull/408): Add option[:id] on static control #245 - [@duleorlovic](https://github.com/duleorlovic).
* [#455](https://github.com/bootstrap-ruby/bootstrap_form/pull/455): Support for i18n `:html` subkeys in help text - [@jsaraiva](https://github.com/jsaraiva).
* Adds support for `label_as_placeholder` option, which will set the label text as an input fields placeholder (and hiding the label for sr_only).
* [#449](https://github.com/bootstrap-ruby/bootstrap_form/pull/449): Passing `.form-row` overrides default `.form-group.row` in horizontal layouts.
* Added an option to the `submit` (and `primary`, by transitivity) form tag helper, `render_as_button`, which when truthy makes the submit button render as a button instead of an input. This allows you to easily provide further styling to your form submission buttons, without requiring you to reinvent the wheel and use the `button` helper (and having to manually insert the typical Bootstrap classes). - [@jsaraiva](https://github.com/jsaraiva).
* Add `:error_message` option to `check_box` and `radio_button`, so they can output validation error messages if needed. [@lcreid](https://github.com/lcreid).
* Your contribution here!

### Bugfixes

* [#357](https://github.com/bootstrap-ruby/bootstrap_form/pull/357) if provided,
  use html option `id` to specify `for` attribute on label
  [@duleorlovic](https://github.com/duleorlovic)


## [2.7.0][] (2017-04-21)

Features:
  * [#325](https://github.com/bootstrap-ruby/bootstrap_form/pull/325): Support :prepend and :append for the `select` helper - [@donv](https://github.com/donv).

## [2.6.0][] (2017-02-03)

Bugfixes:
  - Fix ambiguous first argument warning (#311, @mikenicklas)

Features:
  - Add a FormBuilder#custom_control helper [#289](https://github.com/bootstrap-ruby/bootstrap_form/pull/289)

## [2.5.3][] (2016-12-23)

There are no user-facing changes with this release. Behind the scenes, the tests have been greatly improved. The project is now tested against and compatible with the following Rails versions 4.0, 4.1, 4.2 and 5.0 (#278).

## [2.5.2][] (2016-10-08)

Bugfixes:
  - Allow objects without `model_name`s to act as form objects (#295, @laserlemon)
  - Fix offset for submit for horizontal forms when using non-sm column breakers for label column (#293, @oteyatosys)

## [2.5.1][] (2016-09-23)

Bugfixes:
  - Fix getting help text for elements when using anonymous models (see [issue 282](https://github.com/bootstrap-ruby/bootstrap_form/issues/282))

## [2.5.0][] (2016-08-12)

Bugfixes:

  - Sanitize <label> name (IE `for` attribute) in same manner that Rails sanitizes
    the <input> `id` attribute to fix a11y issue with `for` and `id` mismatch
  - Fix loading of ActionView helpers in combination with RSpec and `rails-controller-testing`. (see [rails-controller-testing/issues#24](https://github.com/rails/rails-controller-testing/issues/24))

Features:

  - Add support for input-group-sm and input-group-lg in prepend/append (#226, @rusanu)
  - Added option to prevent the 'required' CSS class on labels (#205, @LucasAU)

## [2.4.0][] (2016-07-04)

This version is ready to use with Rails 5.0.0!

Bugfixes:

  - Minor README corrections (#184, @msmithstubbs)
  - Fix `alias_method_chain` deprecation warnings when using Rails 5
  - Allow `form_group` to work with frozen string options

Features:

  - Allow primary button classes to be overridden (#183, @tanimichi)
  - Allow to pass a block to select helper in Rails >= 4.1.0 (#229, @doits)

## 2.3.0 (2015-02-17)

Bugfixes:

  - Use #underscore, not #downcase for help text scope (#140, @atipugin)
  - Radio button and checkbox labels will now include the disabled class as needed. (#156, @ScottSwezey)
  - Fixed issue with setting offset in form_group without label in horizontal layout
    when form uses non-default label_col
  - Fixed wrapper options (#153, @veilleperso)
  - Fix errors on non-ActiveRecord setups (#200, @sgnn7)

Features:

  - Allow users to display validation errors in labels (#144, @timcheadle)
  - Use humanized attribute name in label errors (#146, @atipugin)
  - Allow to skip label rendering (#145, @atipugin)
  - Added a `required` CSS class for labels with required attributes (#150, @krsyoung)
  - Added option to customize labels' class.
  - Allow callable value_method and text_method for collection_check_boxes and collection_radio_buttons (#199, @shadwell)

## 2.2.0 (2014-09-16)

Bugfixes:

  - Fixed an exception raised when form_group block returns nil (#111)
  - Fixed an exception on human_attribute_name when using bootstrap_form_tag (#115)
  - Set offset in form_group without label in horizontal layout (#94, @datWav)
  - Fixes an offset bug in form_group without a given label in horizontal layout (#130, @datWav)
  - Fixed bug where collection_check_boxes doesn't work if all are unchecked (#116, @burnt43)

Features:

  - Added the ability to append/prepend buttons (@retoo)
  - Added support for time_zone_select
  - Accept multiple values, and objects as well, on `collection_check_boxes`
    checked option (#114)
  - Added support for hidding attribute name in errors_on helper (@datWav)
  - Added support for additional class to the wrapper form_group by a field (@datWav)
  - Support showing error summaries when inline_errors is enabled (@rosswilson)
  - Name is now optional when creating static controls
  - Keep original form helper methods with _without_bootstrap suffix (#123, @a2ikm)
  - Added glyphicon support
  - Added i18n support for help messages (#122, @huynhquancam)
  - Added the ability to pass any attributes to wrapper (#136, @atipugin)
  - Split monolithic test file into several smaller files (#141, @spacewander)
  - Added role="form" attribute to forms (#142, @spacewander)

## 2.1.1 (2014-04-20)

Bugfixes:

  - Do not reset additional classes on the form-group (@rzane)
  - Fixed an exception when specifying a label while using bootstrap_form_tag

Features:

  - [nested_form](https://github.com/ryanb/nested_form) integration via
    `bootstrap_nested_form_for` (#44 and #66)
  - `form_group` no longer requires a name (#83)

## 2.1.0 (2014-04-01)

Moved GitHub repository from https://github.com/potenza/bootstrap_form
to https://github.com/bootstrap-ruby/bootstrap_form

Bugfixes:

  - i18n fix for checkbox labels (@i10a)
  - Wrapped date & time helpers inside control-specific css classes to prevent stacking
  - control-label class was not being added unless the form was horizontal (@slave2zeros)
  - selects & collection selects were dropping label options
  - allow html content in check_box tag label (@desheikh)
  - allow check_box label to be defined with a block
  - omit form-control class from file_field (@mbrictson)
  - Collection inputs honour `checked` attribute (@desheikh)
  - Fixing label/input pairing for checkbox collections (@byped)
  - Removing for attribute on radio button labels (@sigmike)

Features:

  - The control_class can be overridden per field by passing in the
    :control_class option. Default value is "form-control".
  - Make name optional in FormBuilder#submit (@adrpac)
  - Added the FormBuilder#primary helper back in
  - Added a FormBuilder#static_control helper
  - Added support for radio_buttons_collection and check_boxes_collection
  - Added a FormBuilder#error_summary helper method
  - inline_errors can be turned off: bootstrap_form_for(obj, inline_errors: false)
    When inline errors are off, FormBuilder#alert_message contains the error summary.
    This can also be turned off with the option 'error_summary: false'
  - Added support for: color_field, date_field, datetime_field, datetime_local_field,
    month_field, range_field, search_field (#42), time_field, week_field
  - Added ability to override the left/right classes for a particular control
    when using horizontal forms. (@baldwindavid)
  - Added support for grouped_collection_select (@rzane)
  - Added support of Rails 4 syntax for collection inputs (@desheikh)
  - Renamed options :left to :label_col and :right to :control_col
  - Renamed option :style to :layout (@baldwindavid)
  - Added errors_on helper (@baldwindavid)
  - Added per field layout option (@baldwindavid)
  - Added support for bootstrap_form_tag (@baldwindavid)


[Pending Release]: https://github.com/bootstrap-ruby/bootstrap_form/compare/v4.0.0.alpha1...HEAD
[4.0.0.alpha1]: https://github.com/bootstrap-ruby/bootstrap_form/compare/v2.7.0...v4.0.0.alpha1
[2.7.0]: https://github.com/bootstrap-ruby/bootstrap_form/compare/v2.6.0...v2.7.0
[2.6.0]: https://github.com/bootstrap-ruby/bootstrap_form/compare/v2.5.3...v2.6.0
[2.5.3]: https://github.com/bootstrap-ruby/bootstrap_form/compare/v2.5.2...v2.5.3
[2.5.2]: https://github.com/bootstrap-ruby/bootstrap_form/compare/v2.5.1...v2.5.2
[2.5.1]: https://github.com/bootstrap-ruby/bootstrap_form/compare/v2.5.0...v2.5.1
[2.5.0]: https://github.com/bootstrap-ruby/bootstrap_form/compare/v2.4.0...v2.5.0
[2.4.0]: https://github.com/bootstrap-ruby/bootstrap_form/compare/v2.3.0...v2.4.0
