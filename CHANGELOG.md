## Pending Release

Bugfixes:

  - Minor README corrections (#184, @msmithstubbs)

Features:

  - Allow primary button classes to be overridden (#183, @tanimichi)
  - Added methods for submit buttons with an disable after click (#220, @datWav)

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
to https://github.com/bootstrap-ruby/rails-bootstrap-forms

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
