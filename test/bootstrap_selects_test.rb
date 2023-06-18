require_relative "test_helper"

class BootstrapSelectsTest < ActionView::TestCase
  include BootstrapForm::ActionViewExtensions::FormHelper

  setup :setup_test_fixture

  # Helper to generate options
  def options_range(start: 1, stop: 31, selected: nil, months: false)
    (start..stop).map do |n|
      attr = n == selected ? 'selected="selected"' : ""
      label = months ? Date::MONTHNAMES[n] : n
      "<option #{attr} value=\"#{n}\">#{label}</option>"
    end.join("\n")
  end

  test "time zone selects are wrapped correctly" do
    expected = <<~HTML
      <div class="mb-3">
        <label class="form-label" for="user_misc">Misc</label>
        <select class="form-select" id="user_misc" name="user[misc]">#{time_zone_options_for_select}</select>
      </div>
    HTML
    assert_equivalent_html expected, @builder.time_zone_select(:misc)
  end

  test "time zone selects are wrapped correctly with wrapper" do
    expected = <<~HTML
      <div class="none-margin">
        <label class="form-label" for="user_misc">Misc</label>
        <select class="form-select" id="user_misc" name="user[misc]">#{time_zone_options_for_select}</select>
      </div>
    HTML
    assert_equivalent_html expected, @builder.time_zone_select(:misc, nil, wrapper: { class: "none-margin" })
  end

  test "time zone selects are wrapped correctly with error" do
    @user.errors.add(:misc, "error for test")
    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
        #{'<input name="utf8" type="hidden" value="&#x2713;"/>' unless ::Rails::VERSION::STRING >= '6'}
        <div class="mb-3">
          <label class="form-label" for="user_misc">Misc</label>
          <select class="form-select is-invalid" id="user_misc" name="user[misc]">#{time_zone_options_for_select}</select>
          <div class="invalid-feedback">error for test</div>
        </div>
      </form>
    HTML
    assert_equivalent_html expected, bootstrap_form_for(@user) { |f| f.time_zone_select(:misc) }
  end

  test "selects are wrapped correctly" do
    expected = <<~HTML
      <div class="mb-3">
        <label class="form-label" for="user_status">Status</label>
        <select class="form-select" id="user_status" name="user[status]">
          <option value="1">activated</option>
          <option value="2">blocked</option>
        </select>
      </div>
    HTML
    assert_equivalent_html expected, @builder.select(:status, [["activated", 1], ["blocked", 2]], extra: "extra arg")
  end

  test "bootstrap_specific options are handled correctly" do
    expected = <<~HTML
      <div class="mb-3">
        <label class="form-label" for="user_status">My Status Label</label>
        <select class="form-select" id="user_status" name="user[status]">
          <option value="1">activated</option>
          <option value="2">blocked</option>
        </select>
        <small class="form-text text-muted">Help!</small>
      </div>
    HTML
    assert_equivalent_html expected,
                           @builder.select(:status,
                                           [
                                             ["activated", 1],
                                             ["blocked", 2]
                                           ],
                                           label: "My Status Label",
                                           help: "Help!",
                                           extra: "extra arg")
  end

  test "selects with options are wrapped correctly" do
    expected = <<~HTML
      <div class="mb-3">
        <label class="form-label" for="user_status">Status</label>
        <select class="form-select" id="user_status" name="user[status]">
          <option value="">Please Select</option>
          <option value="1">activated</option>
          <option value="2">blocked</option>
        </select>
      </div>
    HTML
    assert_equivalent_html expected, @builder.select(:status, [["activated", 1], ["blocked", 2]], prompt: "Please Select")
  end

  test "selects with both options and html_options are wrapped correctly" do
    expected = <<~HTML
      <div class="mb-3">
        <label class="form-label" for="user_status">Status</label>
        <select class="form-select my-select" extra="extra arg" id="user_status" name="user[status]">
          <option value="">Please Select</option>
          <option value="1">activated</option>
          <option value="2">blocked</option>
        </select>
      </div>
    HTML
    assert_equivalent_html expected,
                           @builder.select(:status, [["activated", 1], ["blocked", 2]], { prompt: "Please Select" },
                                           class: "my-select", extra: "extra arg")
  end

  test "select 'id' attribute is used to specify label 'for' attribute" do
    expected = <<~HTML
      <div class="mb-3">
        <label class="form-label" for="custom_id">Status</label>
        <select class="form-select" id="custom_id" name="user[status]">
          <option value="">Please Select</option>
          <option value="1">activated</option>
          <option value="2">blocked</option>
        </select>
      </div>
    HTML
    assert_equivalent_html expected,
                           @builder.select(:status, [["activated", 1], ["blocked", 2]], { prompt: "Please Select" },
                                           id: "custom_id")
  end

  test "selects with addons are wrapped correctly" do
    expected = <<~HTML
      <div class="mb-3">
        <label class="form-label" for="user_status">Status</label>
        <div class="input-group">
          <span class="input-group-text">Before</span>
          <select class="form-select" id="user_status" name="user[status]">
            <option value="1">activated</option>
            <option value="2">blocked</option>
          </select>
          <span class="input-group-text">After</span>
        </div>
      </div>
    HTML
    assert_equivalent_html expected,
                           @builder.select(:status, [["activated", 1], ["blocked", 2]], prepend: "Before", append: "After")
  end

  test "selects with block use block as content" do
    expected = <<~HTML
      <div class="mb-3">
        <label class="form-label" for="user_status">Status</label>
        <select class="form-select" name="user[status]" id="user_status">
          <option>Option 1</option>
          <option>Option 2</option>
        </select>
      </div>
    HTML
    select = @builder.select(:status) do
      tag.option { "Option 1" } +
        tag.option { "Option 2" }
    end
    assert_equivalent_html expected, select
  end

  test "selects render labels properly" do
    expected = <<~HTML
      <div class="mb-3">
        <label class="form-label" for="user_status">User Status</label>
        <select class="form-select" id="user_status" name="user[status]">
          <option value="1">activated</option>
          <option value="2">blocked</option>
        </select>
      </div>
    HTML
    assert_equivalent_html expected, @builder.select(:status, [["activated", 1], ["blocked", 2]], label: "User Status")
  end

  test "collection_selects are wrapped correctly" do
    expected = <<~HTML
      <div class="mb-3">
        <label class="form-label" for="user_status">Status</label>
        <select class="form-select" id="user_status" name="user[status]"></select>
      </div>
    HTML
    assert_equivalent_html expected, @builder.collection_select(:status, [], :id, :name, extra: "extra arg")
  end

  test "collection_selects are wrapped correctly with wrapper" do
    expected = <<~HTML
      <div class="none-margin">
        <label class="form-label" for="user_status">Status</label>
        <select class="form-select" id="user_status" name="user[status]"></select>
      </div>
    HTML
    assert_equivalent_html expected, @builder.collection_select(:status, [], :id, :name, wrapper: { class: "none-margin" })
  end

  test "collection_selects are wrapped correctly with error" do
    @user.errors.add(:status, "error for test")
    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
        #{'<input name="utf8" type="hidden" value="&#x2713;"/>' unless ::Rails::VERSION::STRING >= '6'}
        <div class="mb-3">
          <label class="form-label" for="user_status">Status</label>
          <select class="form-select is-invalid" id="user_status" name="user[status]"></select>
          <div class="invalid-feedback">error for test</div>
        </div>
      </form>
    HTML
    assert_equivalent_html expected, bootstrap_form_for(@user) { |f| f.collection_select(:status, [], :id, :name) }
  end

  test "collection_selects with options are wrapped correctly" do
    expected = <<~HTML
      <div class="mb-3">
        <label class="form-label" for="user_status">Status</label>
        <select class="form-select" id="user_status" name="user[status]">
          <option value="">Please Select</option>
        </select>
      </div>
    HTML
    assert_equivalent_html expected, @builder.collection_select(:status, [], :id, :name, prompt: "Please Select")
  end

  test "collection_selects with options and html_options are wrapped correctly" do
    expected = <<~HTML
      <div class="mb-3">
        <label class="form-label" for="user_status">Status</label>
        <select class="form-select my-select" id="user_status" name="user[status]">
          <option value="">Please Select</option>
        </select>
      </div>
    HTML
    assert_equivalent_html expected,
                           @builder.collection_select(:status, [], :id, :name, { prompt: "Please Select" }, class: "my-select")
  end

  test "collection_selects with addons are wrapped correctly" do
    expected = <<~HTML
      <div class="mb-3">
        <label class="form-label" for="user_status">Status</label>
        <div class="input-group">
          <span class="input-group-text">Before</span>
          <select class="form-select" id="user_status" name="user[status]">
            <option value="">Please Select</option>
          </select>
          <span class="input-group-text">After</span>
        </div>
      </div>
    HTML
    assert_equivalent_html expected,
                           @builder.collection_select(:status, [], :id, :name,
                                                      { prepend: "Before", append: "After", prompt: "Please Select" })
  end

  test "grouped_collection_selects are wrapped correctly" do
    expected = <<~HTML
      <div class="mb-3">
        <label class="form-label" for="user_status">Status</label>
        <select class="form-select" id="user_status" name="user[status]"></select>
      </div>
    HTML
    assert_equivalent_html expected,
                           @builder.grouped_collection_select(:status, [], :last, :first, :to_s, :to_s, extra: "extra arg")
  end

  test "grouped_collection_selects are wrapped correctly with wrapper" do
    expected = <<~HTML
      <div class="none-margin">
        <label class="form-label" for="user_status">Status</label>
        <select class="form-select" id="user_status" name="user[status]"></select>
      </div>
    HTML
    assert_equivalent_html expected,
                           @builder.grouped_collection_select(:status, [], :last, :first, :to_s, :to_s,
                                                              wrapper_class: "none-margin")
  end

  test "grouped_collection_selects are wrapped correctly with error" do
    @user.errors.add(:status, "error for test")
    expected = <<~HTML
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
        #{'<input name="utf8" type="hidden" value="&#x2713;"/>' unless ::Rails::VERSION::STRING >= '6'}
        <div class="mb-3">
          <label class="form-label" for="user_status">Status</label>
          <select class="form-select is-invalid" id="user_status" name="user[status]"></select>
          <div class="invalid-feedback">error for test</div>
        </div>
      </form>
    HTML
    assert_equivalent_html expected,
                           bootstrap_form_for(@user) { |f| f.grouped_collection_select(:status, [], :last, :first, :to_s, :to_s) }
  end

  test "grouped_collection_selects with options are wrapped correctly" do
    expected = <<~HTML
      <div class="mb-3">
        <label class="form-label" for="user_status">Status</label>
        <select class="form-select" id="user_status" name="user[status]">
          <option value="">Please Select</option>
        </select>
      </div>
    HTML
    assert_equivalent_html expected,
                           @builder.grouped_collection_select(:status, [], :last, :first, :to_s, :to_s, prompt: "Please Select")
  end

  test "grouped_collection_selects with options and html_options are wrapped correctly" do
    expected = <<~HTML
      <div class="mb-3">
        <label class="form-label" for="user_status">Status</label>
        <select class="form-select my-select" id="user_status" name="user[status]">
          <option value="">Please Select</option>
        </select>
      </div>
    HTML
    assert_equivalent_html expected,
                           @builder.grouped_collection_select(:status, [], :last, :first, :to_s, :to_s, { prompt: "Please Select" },
                                                              class: "my-select")
  end

  test "grouped_collection_selects with addons are wrapped correctly" do
    expected = <<~HTML
      <div class="mb-3">
        <label class="form-label" for="user_status">Status</label>
        <div class="input-group">
          <span class="input-group-text">Before</span>
          <select class="form-select" id="user_status" name="user[status]">
            <option value="">Please Select</option>
          </select>
          <span class="input-group-text">After</span>
        </div>
      </div>
    HTML
    assert_equivalent_html expected,
                           @builder.grouped_collection_select(:status, [], :last, :first, :to_s, :to_s,
                                                              { prepend: "Before", append: "After", prompt: "Please Select" })
  end

  test "date selects are wrapped correctly" do
    travel_to(Time.utc(2012, 2, 3)) do
      expected = <<~HTML
        <div class="mb-3">
          <label class="form-label" for="user_misc">Misc</label>
          <div class="rails-bootstrap-forms-date-select">
            <select class="form-select" id="user_misc_1i" name="user[misc(1i)]">
              #{options_range(start: 2007, stop: 2017, selected: 2012)}
            </select>
            <select class="form-select" id="user_misc_2i" name="user[misc(2i)]">
              #{options_range(start: 1, stop: 12, selected: 2, months: true)}
            </select>
            <select class="form-select" id="user_misc_3i" name="user[misc(3i)]">
              #{options_range(start: 1, stop: 31, selected: 3)}
            </select>
          </div>
        </div>
      HTML
      assert_equivalent_html expected, @builder.date_select(:misc)
    end
  end

  test "date selects are wrapped correctly with wrapper class" do
    travel_to(Time.utc(2012, 2, 3)) do
      expected = <<~HTML
        <div class="none-margin">
          <label class="form-label" for="user_misc">Misc</label>
          <div class="rails-bootstrap-forms-date-select">
            <select class="form-select" id="user_misc_1i" name="user[misc(1i)]">
              #{options_range(start: 2007, stop: 2017, selected: 2012)}
            </select>
            <select class="form-select" id="user_misc_2i" name="user[misc(2i)]">
              #{options_range(start: 1, stop: 12, selected: 2, months: true)}
            </select>
            <select class="form-select" id="user_misc_3i" name="user[misc(3i)]">
              #{options_range(start: 1, stop: 31, selected: 3)}
            </select>
          </div>
        </div>
      HTML
      assert_equivalent_html expected, @builder.date_select(:misc, wrapper_class: "none-margin", extra: "extra arg")
    end
  end

  test "date selects inline when layout is horizontal" do
    travel_to(Time.utc(2012, 2, 3)) do
      expected = <<~HTML
        <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
          #{'<input name="utf8" type="hidden" value="&#x2713;"/>' unless ::Rails::VERSION::STRING >= '6'}
          <div class="mb-3 row">
            <label class="col-form-label col-sm-2" for="user_misc">Misc</label>
            <div class="col-sm-10">
              <div class="rails-bootstrap-forms-date-select col-auto g-3">
                <select class="form-select" id="user_misc_1i" name="user[misc(1i)]">
                  #{options_range(start: 2007, stop: 2017, selected: 2012)}
                </select>
                <select class="form-select" id="user_misc_2i" name="user[misc(2i)]">
                  #{options_range(start: 1, stop: 12, selected: 2, months: true)}
                </select>
                <select class="form-select" id="user_misc_3i" name="user[misc(3i)]">
                  #{options_range(start: 1, stop: 31, selected: 3)}
                </select>
              </div>
            </div>
          </div>
        </form>
      HTML
      assert_equivalent_html expected, bootstrap_form_for(@user, layout: :horizontal) { |f| f.date_select(:misc) }
    end
  end

  test "date selects are wrapped correctly with error" do
    @user.errors.add(:misc, "error for test")
    travel_to(Time.utc(2012, 2, 3)) do
      expected = <<~HTML
        <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
          #{'<input name="utf8" type="hidden" value="&#x2713;"/>' unless ::Rails::VERSION::STRING >= '6'}
          <div class="mb-3">
            <label class="form-label" for="user_misc">Misc</label>
            <div class="rails-bootstrap-forms-date-select">
              <select class="form-select is-invalid" id="user_misc_1i" name="user[misc(1i)]">
                #{options_range(start: 2007, stop: 2017, selected: 2012)}
              </select>
              <select class="form-select is-invalid" id="user_misc_2i" name="user[misc(2i)]">
                #{options_range(start: 1, stop: 12, selected: 2, months: true)}
              </select>
              <select class="form-select is-invalid" id="user_misc_3i" name="user[misc(3i)]">
                #{options_range(start: 1, stop: 31, selected: 3)}
              </select>
              <div class="invalid-feedback">error for test</div>
            </div>
          </div>
        </form>
      HTML
      assert_equivalent_html expected, bootstrap_form_for(@user) { |f| f.date_select(:misc) }
    end
  end

  test "date selects with options are wrapped correctly" do
    travel_to(Time.utc(2012, 2, 3)) do
      expected = <<~HTML
        <div class="mb-3">
          <label class="form-label" for="user_misc">Misc</label>
          <div class="rails-bootstrap-forms-date-select">
            <select class="form-select" id="user_misc_1i" name="user[misc(1i)]">
              #{blank_option}
              #{options_range(start: 2007, stop: 2017)}
            </select>
            <select class="form-select" id="user_misc_2i" name="user[misc(2i)]">
              #{blank_option}
              #{options_range(start: 1, stop: 12, months: true)}
            </select>
            <select class="form-select" id="user_misc_3i" name="user[misc(3i)]">
              #{blank_option}
              #{options_range(start: 1, stop: 31)}
            </select>
          </div>
        </div>
      HTML

      assert_equivalent_html expected, @builder.date_select(:misc, include_blank: true)
    end
  end

  test "date selects with options and html_options are wrapped correctly" do
    travel_to(Time.utc(2012, 2, 3)) do
      expected = <<~HTML
        <div class="mb-3">
          <label class="form-label" for="user_misc">Misc</label>
          <div class="rails-bootstrap-forms-date-select">
            <select class="form-select my-date-select" id="user_misc_1i" name="user[misc(1i)]">
              #{blank_option}
              #{options_range(start: 2007, stop: 2017)}
            </select>
            <select class="form-select my-date-select" id="user_misc_2i" name="user[misc(2i)]">
              #{blank_option}
              #{options_range(start: 1, stop: 12, months: true)}
            </select>
            <select class="form-select my-date-select" id="user_misc_3i" name="user[misc(3i)]">
              #{blank_option}
              #{options_range(start: 1, stop: 31)}
            </select>
          </div>
        </div>
      HTML
      assert_equivalent_html expected, @builder.date_select(:misc, { include_blank: true }, class: "my-date-select")
    end
  end

  test "time selects are wrapped correctly" do
    travel_to(Time.utc(2012, 2, 3, 12, 0, 0)) do
      expected = <<~HTML
        <div class="mb-3">
          <label class="form-label" for="user_misc">Misc</label>
          <div class="rails-bootstrap-forms-time-select">
            <input #{autocomplete_attr} id="user_misc_1i" name="user[misc(1i)]" type="hidden" value="2012" />
            <input #{autocomplete_attr} id="user_misc_2i" name="user[misc(2i)]" type="hidden" value="2" />
            <input #{autocomplete_attr} id="user_misc_3i" name="user[misc(3i)]" type="hidden" value="3" />
            <select class="form-select" id="user_misc_4i" name="user[misc(4i)]">
              #{options_range(start: '00', stop: '23', selected: '12')}
            </select>
            :
            <select class="form-select" id="user_misc_5i" name="user[misc(5i)]">
              #{options_range(start: '00', stop: '59', selected: '00')}
            </select>
          </div>
        </div>
      HTML
      assert_equivalent_html expected, @builder.time_select(:misc, extra: "extra arg")
    end
  end

  test "time selects are wrapped correctly with error" do
    @user.errors.add(:misc, "error for test")
    travel_to(Time.utc(2012, 2, 3, 12, 0, 0)) do
      expected = <<~HTML
        <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
          #{'<input name="utf8" type="hidden" value="&#x2713;"/>' unless ::Rails::VERSION::STRING >= '6'}
          <div class="mb-3">
            <label class="form-label" for="user_misc">Misc</label>
            <div class="rails-bootstrap-forms-time-select">
              <input #{autocomplete_attr} id="user_misc_1i" name="user[misc(1i)]" type="hidden" value="2012" />
              <input #{autocomplete_attr} id="user_misc_2i" name="user[misc(2i)]" type="hidden" value="2" />
              <input #{autocomplete_attr} id="user_misc_3i" name="user[misc(3i)]" type="hidden" value="3" />
              <select class="form-select is-invalid" id="user_misc_4i" name="user[misc(4i)]">
                #{options_range(start: '00', stop: '23', selected: '12')}
              </select>
              :
              <select class="form-select is-invalid" id="user_misc_5i" name="user[misc(5i)]">
                #{options_range(start: '00', stop: '59', selected: '00')}
              </select>
              <div class="invalid-feedback">error for test</div>
            </div>
          </div>
        </form>
      HTML
      assert_equivalent_html expected, bootstrap_form_for(@user) { |f| f.time_select(:misc) }
    end
  end

  test "time selects with options are wrapped correctly" do
    travel_to(Time.utc(2012, 2, 3, 12, 0, 0)) do
      expected = <<~HTML
        <div class="mb-3">
          <label class="form-label" for="user_misc">Misc</label>
          <div class="rails-bootstrap-forms-time-select">
            <input #{autocomplete_attr} id="user_misc_1i" name="user[misc(1i)]" type="hidden" value="1" />
            <input #{autocomplete_attr} id="user_misc_2i" name="user[misc(2i)]" type="hidden" value="1" />
            <input #{autocomplete_attr} id="user_misc_3i" name="user[misc(3i)]" type="hidden" value="1" />
            <select class="form-select" id="user_misc_4i" name="user[misc(4i)]">
              #{blank_option}
              #{options_range(start: '00', stop: '23')}
            </select>
            :
            <select class="form-select" id="user_misc_5i" name="user[misc(5i)]">
              #{blank_option}
              #{options_range(start: '00', stop: '59')}
            </select>
          </div>
        </div>
      HTML
      assert_equivalent_html expected, @builder.time_select(:misc, include_blank: true)
    end
  end

  test "time selects with options and html_options are wrapped correctly" do
    travel_to(Time.utc(2012, 2, 3, 12, 0, 0)) do
      expected = <<~HTML
        <div class="mb-3">
          <label class="form-label" for="user_misc">Misc</label>
          <div class="rails-bootstrap-forms-time-select">
            <input #{autocomplete_attr} id="user_misc_1i" name="user[misc(1i)]" type="hidden" value="1" />
            <input #{autocomplete_attr} id="user_misc_2i" name="user[misc(2i)]" type="hidden" value="1" />
            <input #{autocomplete_attr} id="user_misc_3i" name="user[misc(3i)]" type="hidden" value="1" />
            <select class="form-select my-time-select" id="user_misc_4i" name="user[misc(4i)]">
              #{blank_option}
              #{options_range(start: '00', stop: '23')}
            </select>
            :
            <select class="form-select my-time-select" id="user_misc_5i" name="user[misc(5i)]">
              #{blank_option}
              #{options_range(start: '00', stop: '59')}
            </select>
          </div>
        </div>
      HTML
      assert_equivalent_html expected, @builder.time_select(:misc, { include_blank: true }, class: "my-time-select")
    end
  end

  test "datetime selects are wrapped correctly" do
    travel_to(Time.utc(2012, 2, 3, 12, 0, 0)) do
      expected = <<~HTML
        <div class="mb-3">
          <label class="form-label" for="user_misc">Misc</label>
          <div class="rails-bootstrap-forms-datetime-select">
            <select class="form-select" id="user_misc_1i" name="user[misc(1i)]">
              #{options_range(start: 2007, stop: 2017, selected: 2012)}
            </select>
            <select class="form-select" id="user_misc_2i" name="user[misc(2i)]">
              #{options_range(start: 1, stop: 12, selected: 2, months: true)}
            </select>
            <select class="form-select" id="user_misc_3i" name="user[misc(3i)]">
              #{options_range(start: 1, stop: 31, selected: 3)}
            </select>
            &mdash;
            <select class="form-select" id="user_misc_4i" name="user[misc(4i)]">
              #{options_range(start: '00', stop: '23', selected: '12')}
            </select>
            :
            <select class="form-select" id="user_misc_5i" name="user[misc(5i)]">
              #{options_range(start: '00', stop: '59', selected: '00')}
            </select>
          </div>
        </div>
      HTML
      assert_equivalent_html expected, @builder.datetime_select(:misc)
    end
  end

  test "datetime selects are wrapped correctly with error" do
    @user.errors.add(:misc, "error for test")
    travel_to(Time.utc(2012, 2, 3, 12, 0, 0)) do
      expected = <<~HTML
        <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post">
          #{'<input name="utf8" type="hidden" value="&#x2713;"/>' unless ::Rails::VERSION::STRING >= '6'}
          <div class="mb-3">
            <label class="form-label" for="user_misc">Misc</label>
            <div class="rails-bootstrap-forms-datetime-select">
              <select class="form-select is-invalid" id="user_misc_1i" name="user[misc(1i)]">
                #{options_range(start: 2007, stop: 2017, selected: 2012)}
              </select>
              <select class="form-select is-invalid" id="user_misc_2i" name="user[misc(2i)]">
                #{options_range(start: 1, stop: 12, selected: 2, months: true)}
              </select>
              <select class="form-select is-invalid" id="user_misc_3i" name="user[misc(3i)]">
                #{options_range(start: 1, stop: 31, selected: 3)}
              </select>
              &mdash;
              <select class="form-select is-invalid" id="user_misc_4i" name="user[misc(4i)]">
                #{options_range(start: '00', stop: '23', selected: '12')}
              </select>
              :
              <select class="form-select is-invalid" id="user_misc_5i" name="user[misc(5i)]">
                #{options_range(start: '00', stop: '59', selected: '00')}
              </select>
              <div class="invalid-feedback">error for test</div>
            </div>
          </div>
        </form>
      HTML
      assert_equivalent_html expected, bootstrap_form_for(@user) { |f| f.datetime_select(:misc) }
    end
  end

  test "datetime selects with options are wrapped correctly" do
    travel_to(Time.utc(2012, 2, 3, 12, 0, 0)) do
      expected = <<~HTML
        <div class="mb-3">
          <label class="form-label" for="user_misc">Misc</label>
          <div class="rails-bootstrap-forms-datetime-select">
            <select class="form-select" id="user_misc_1i" name="user[misc(1i)]">
              #{blank_option}
              #{options_range(start: 2007, stop: 2017)}
            </select>
            <select class="form-select" id="user_misc_2i" name="user[misc(2i)]">
              #{blank_option}
              #{options_range(start: 1, stop: 12, months: true)}
            </select>
            <select class="form-select" id="user_misc_3i" name="user[misc(3i)]">
              #{blank_option}
              #{options_range(start: 1, stop: 31)}
            </select>
            &mdash;
            <select class="form-select" id="user_misc_4i" name="user[misc(4i)]">
              #{blank_option}
              #{options_range(start: '00', stop: '23')}
            </select>
            :
            <select class="form-select" id="user_misc_5i" name="user[misc(5i)]">
              #{blank_option}
              #{options_range(start: '00', stop: '59')}
            </select>
          </div>
        </div>
      HTML
      assert_equivalent_html expected, @builder.datetime_select(:misc, include_blank: true)
    end
  end

  test "datetime selects with options and html_options are wrapped correctly" do
    travel_to(Time.utc(2012, 2, 3, 12, 0, 0)) do
      expected = <<~HTML
        <div class="mb-3">
          <label class="form-label" for="user_misc">Misc</label>
          <div class="rails-bootstrap-forms-datetime-select">
            <select class="form-select my-datetime-select" extra="extra arg" id="user_misc_1i" name="user[misc(1i)]">
              #{blank_option}
              #{options_range(start: 2007, stop: 2017)}
            </select>
            <select class="form-select my-datetime-select" extra="extra arg" id="user_misc_2i" name="user[misc(2i)]">
              #{blank_option}
              #{options_range(start: 1, stop: 12, months: true)}
            </select>
            <select class="form-select my-datetime-select" extra="extra arg" id="user_misc_3i" name="user[misc(3i)]">
              #{blank_option}
              #{options_range(start: 1, stop: 31)}
            </select>
            &mdash;
            <select class="form-select my-datetime-select" extra="extra arg" id="user_misc_4i" name="user[misc(4i)]">
              #{blank_option}
              #{options_range(start: '00', stop: '23')}
            </select>
            :
            <select class="form-select my-datetime-select" extra="extra arg" id="user_misc_5i" name="user[misc(5i)]">
              #{blank_option}
              #{options_range(start: '00', stop: '59')}
            </select>
          </div>
        </div>
      HTML
      assert_equivalent_html expected, @builder.datetime_select(:misc,
                                                                { include_blank: true },
                                                                class: "my-datetime-select",
                                                                extra: "extra arg")
    end
  end

  test "confirm documentation example for HTML options" do
    expected = <<~HTML
      <div class="mb-3 has-warning" data-foo="bar">
        <label class="form-label" for="user_misc">Choose your favorite fruit:</label>
        <select class="form-select selectpicker" id="user_misc" name="user[misc]">
          <option value="1">Apple</option>
          <option value="2">Grape</option>
        </select>
      </div>
    HTML
    assert_equivalent_html expected,
                           @builder.select(:misc,
                                           [["Apple", 1], ["Grape", 2]],
                                           {
                                             label: "Choose your favorite fruit:",
                                             wrapper: { class: "mb-3 has-warning", data: { foo: "bar" } }
                                           },
                                           class: "selectpicker")
  end

  test "can have a floating label" do
    expected = <<~HTML
      <div class="mb-3 form-floating">
        <select class="form-select" id="user_misc" name="user[misc]">
          <option value="1">Apple</option>
          <option value="2">Grape</option>
        </select>
        <label class="form-label" for="user_misc">Misc</label>
      </div>
    HTML
    assert_equivalent_html expected, @builder.select(:misc, [["Apple", 1], ["Grape", 2]], floating: true)
  end

  def blank_option
    if ::Rails::VERSION::STRING < "6.1"
      '<option value=""></option>'
    else
      '<option label=" " value=""></option>'
    end
  end
end
