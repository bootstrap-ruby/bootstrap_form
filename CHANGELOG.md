## 2.1.0

Moved GitHub repository from https://github.com/potenza/bootstrap_form
to https://github.com/bootstrap-ruby/rails-bootstrap-forms

Bugfixes:

  - omit form-control class from file_field (@mbrictson)
  - allow check_box label to be defined with a block
  - allow html content in check_box tag label (@desheikh)
  - selects & collection selects were dropping label options
  - control-label class was not being added unless the form was horizontal (@slave2zeros)
  - Wrapped date & time helpers inside control-specific css classes to prevent stacking
  - i18n fix for checkbox labels (@i10a)

Features:

  - Added ability to override the left/right classes for a particular control
    when using horizontal forms. (@baldwindavid)
  - Added support for: color_field, date_field, datetime_field, datetime_local_field,
    month_field, range_field, search_field (#42), time_field, week_field
  - inline_errors can be turned off: bootstrap_form_for(obj, inline_errors: false)
    When inline errors are off, FormBuilder#alert_message contains the error summary.
    This can also be turned off with the option 'error_summary: false'
  - Added a FormBuilder#error_summary helper method
  - Added support for radio_buttons_collection and check_boxes_collection
  - Added a FormBuilder#static_control helper
  - Added the FormBuilder#primary helper back in
  - Make name optional in FormBuilder#submit (@adrpac)
  - The control_class can be overridden per field by passing in the :control_class option. Default value is "form-control".
