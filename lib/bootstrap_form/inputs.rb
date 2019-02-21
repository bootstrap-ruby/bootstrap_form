# frozen_string_literal: true

module BootstrapForm
  module Inputs
    extend ActiveSupport::Autoload

    autoload :Base
    autoload :InputsCollection
    autoload :CheckBox
    autoload :CollectionCheckBoxes
    autoload :CollectionRadioButtons
    autoload :CollectionSelect
    autoload :ColorField
    autoload :DateField
    autoload :DateSelect
    autoload :DatetimeField
    autoload :DatetimeLocalField
    autoload :DatetimeSelect
    autoload :EmailField
    autoload :FileField
    autoload :GroupedCollectionSelect
    autoload :MonthField
    autoload :NumberField
    autoload :PasswordField
    autoload :PhoneField
    autoload :RadioButton
    autoload :RangeField
    autoload :RichTextArea if Rails::VERSION::MAJOR >= 6
    autoload :SearchField
    autoload :Select
    autoload :TelephoneField
    autoload :TextArea
    autoload :TextField
    autoload :TimeField
    autoload :TimeSelect
    autoload :TimeZoneSelect
    autoload :UrlField
    autoload :WeekField
  end
end
