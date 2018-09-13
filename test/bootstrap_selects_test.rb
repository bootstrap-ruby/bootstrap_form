require_relative "./test_helper"

class BootstrapSelectsTest < ActionView::TestCase
  include BootstrapForm::Helper

  setup :setup_test_fixture

  # Helper to generate options
  def options_range(start: 1, stop: 31, selected: nil, months: false)
    (start..stop).map do |n|
      attr = (n == selected) ? 'selected="selected"' : ""
      label = months ? Date::MONTHNAMES[n] : n
      "<option #{attr} value=\"#{n}\">#{label}</option>"
    end.join("\n")
  end

  test "time zone selects are wrapped correctly" do
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label for="user_misc">Misc</label>
        <select class="form-control" id="user_misc" name="user[misc]">#{time_zone_options_for_select}</select>
      </div>
    HTML
    assert_equivalent_xml expected, @builder.time_zone_select(:misc)
  end

  test "time zone selects are wrapped correctly with wrapper" do
    expected = <<-HTML.strip_heredoc
      <div class="form-group none-margin">
        <label for="user_misc">Misc</label>
        <select class="form-control" id="user_misc" name="user[misc]">#{time_zone_options_for_select}</select>
      </div>
    HTML
    assert_equivalent_xml expected, @builder.time_zone_select(:misc, nil, wrapper: { class: "none-margin" })
  end

  test "time zone selects are wrapped correctly with error" do
    @user.errors.add(:misc, "error for test")
    expected = <<-HTML.strip_heredoc
    <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post" role="form">
      <input name="utf8" type="hidden" value="&#x2713;"/>
      <div class="form-group">
        <label for="user_misc">Misc</label>
        <select class="form-control is-invalid" id="user_misc" name="user[misc]">#{time_zone_options_for_select}</select>
        <div class="invalid-feedback">error for test</div>
      </div>
    </form>
    HTML
    assert_equivalent_xml expected, bootstrap_form_for(@user) { |f| f.time_zone_select(:misc) }
  end

  test "selects are wrapped correctly" do
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label for="user_status">Status</label>
        <select class="form-control" id="user_status" name="user[status]">
          <option value="1">activated</option>
          <option value="2">blocked</option>
        </select>
      </div>
    HTML
    assert_equivalent_xml expected, @builder.select(:status, [['activated', 1], ['blocked', 2]])
  end

  test "bootstrap_specific options are handled correctly" do
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label for="user_status">My Status Label</label>
        <select class="form-control" id="user_status" name="user[status]">
          <option value="1">activated</option>
          <option value="2">blocked</option>
        </select>
        <small class="form-text text-muted">Help!</small>
      </div>
    HTML
    assert_equivalent_xml expected, @builder.select(:status, [['activated', 1], ['blocked', 2]], label: "My Status Label", help: "Help!" )
  end

  test "selects with options are wrapped correctly" do
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label for="user_status">Status</label>
        <select class="form-control" id="user_status" name="user[status]">
          <option value="">Please Select</option>
          <option value="1">activated</option>
          <option value="2">blocked</option>
        </select>
      </div>
    HTML
    assert_equivalent_xml expected, @builder.select(:status, [['activated', 1], ['blocked', 2]], prompt: "Please Select")
  end

  test "selects with both options and html_options are wrapped correctly" do
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label for="user_status">Status</label>
        <select class="form-control my-select" id="user_status" name="user[status]">
          <option value="">Please Select</option>
          <option value="1">activated</option>
          <option value="2">blocked</option>
        </select>
      </div>
    HTML
    assert_equivalent_xml expected, @builder.select(:status, [['activated', 1], ['blocked', 2]], { prompt: "Please Select" }, class: "my-select")
  end

  test "select 'id' attribute is used to specify label 'for' attribute" do
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label for="custom_id">Status</label>
        <select class="form-control" id="custom_id" name="user[status]">
          <option value="">Please Select</option>
          <option value="1">activated</option>
          <option value="2">blocked</option>
        </select>
      </div>
    HTML
    assert_equivalent_xml expected, @builder.select(:status, [['activated', 1], ['blocked', 2]], { prompt: "Please Select" }, id: "custom_id")
  end

  test 'selects with addons are wrapped correctly' do
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label for="user_status">Status</label>
        <div class="input-group">
          <div class="input-group-prepend"><span class="input-group-text">Before</span></div>
          <select class="form-control" id="user_status" name="user[status]">
            <option value="1">activated</option>
            <option value="2">blocked</option>
          </select>
          <div class="input-group-append"><span class="input-group-text">After</span></div>
        </div>
      </div>
    HTML
    assert_equivalent_xml expected, @builder.select(:status, [['activated', 1], ['blocked', 2]], prepend: 'Before', append: 'After')
  end

  test "selects with block use block as content" do
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label for="user_status">Status</label>
        <select class="form-control" name="user[status]" id="user_status">
          <option>Option 1</option>
          <option>Option 2</option>
        </select>
      </div>
    HTML
    select = @builder.select(:status) do
      content_tag(:option) { 'Option 1' } +
      content_tag(:option) { 'Option 2' }
    end
    assert_equivalent_xml expected, select
  end

  test "selects render labels properly" do
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label for="user_status">User Status</label>
        <select class="form-control" id="user_status" name="user[status]">
          <option value="1">activated</option>
          <option value="2">blocked</option>
        </select>
      </div>
    HTML
    assert_equivalent_xml expected, @builder.select(:status, [['activated', 1], ['blocked', 2]], label: "User Status")
  end

  test "collection_selects are wrapped correctly" do
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label for="user_status">Status</label>
        <select class="form-control" id="user_status" name="user[status]"></select>
      </div>
    HTML
    assert_equivalent_xml expected, @builder.collection_select(:status, [], :id, :name)
  end

  test "collection_selects are wrapped correctly with wrapper" do
    expected = <<-HTML.strip_heredoc
      <div class="form-group none-margin">
        <label for="user_status">Status</label>
        <select class="form-control" id="user_status" name="user[status]"></select>
      </div>
    HTML
    assert_equivalent_xml expected, @builder.collection_select(:status, [], :id, :name, wrapper: { class: "none-margin" })
  end

  test "collection_selects are wrapped correctly with error" do
    @user.errors.add(:status, "error for test")
    expected = <<-HTML.strip_heredoc
    <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post" role="form">
      <input name="utf8" type="hidden" value="&#x2713;"/>
      <div class="form-group">
        <label for="user_status">Status</label>
        <select class="form-control is-invalid" id="user_status" name="user[status]"></select>
        <div class="invalid-feedback">error for test</div>
      </div>
    </form>
    HTML
    assert_equivalent_xml expected, bootstrap_form_for(@user) { |f| f.collection_select(:status, [], :id, :name) }
  end

  test "collection_selects with options are wrapped correctly" do
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label for="user_status">Status</label>
        <select class="form-control" id="user_status" name="user[status]">
          <option value="">Please Select</option>
        </select>
      </div>
    HTML
    assert_equivalent_xml expected, @builder.collection_select(:status, [], :id, :name, prompt: "Please Select")
  end

  test "collection_selects with options and html_options are wrapped correctly" do
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label for="user_status">Status</label>
        <select class="form-control my-select" id="user_status" name="user[status]">
          <option value="">Please Select</option>
        </select>
      </div>
    HTML
    assert_equivalent_xml expected, @builder.collection_select(:status, [], :id, :name, { prompt: "Please Select" }, class: "my-select")
  end

  test "grouped_collection_selects are wrapped correctly" do
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label for="user_status">Status</label>
        <select class="form-control" id="user_status" name="user[status]"></select>
      </div>
    HTML
    assert_equivalent_xml expected, @builder.grouped_collection_select(:status, [], :last, :first, :to_s, :to_s)
  end

  test "grouped_collection_selects are wrapped correctly with wrapper" do
    expected = <<-HTML.strip_heredoc
      <div class="form-group none-margin">
        <label for="user_status">Status</label>
        <select class="form-control" id="user_status" name="user[status]"></select>
      </div>
    HTML
    assert_equivalent_xml expected, @builder.grouped_collection_select(:status, [], :last, :first, :to_s, :to_s, wrapper_class: "none-margin")
  end

  test "grouped_collection_selects are wrapped correctly with error" do
    @user.errors.add(:status, "error for test")
    expected = <<-HTML.strip_heredoc
    <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post" role="form">
      <input name="utf8" type="hidden" value="&#x2713;"/>
      <div class="form-group">
        <label for="user_status">Status</label>
        <select class="form-control is-invalid" id="user_status" name="user[status]"></select>
        <div class="invalid-feedback">error for test</div>
      </div>
    </form>
    HTML
    assert_equivalent_xml expected, bootstrap_form_for(@user) { |f| f.grouped_collection_select(:status, [], :last, :first, :to_s, :to_s) }
  end

  test "grouped_collection_selects with options are wrapped correctly" do
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label for="user_status">Status</label>
        <select class="form-control" id="user_status" name="user[status]">
          <option value="">Please Select</option>
        </select>
      </div>
    HTML
    assert_equivalent_xml expected, @builder.grouped_collection_select(:status, [], :last, :first, :to_s, :to_s, prompt: "Please Select")
  end

  test "grouped_collection_selects with options and html_options are wrapped correctly" do
    expected = <<-HTML.strip_heredoc
      <div class="form-group">
        <label for="user_status">Status</label>
        <select class="form-control my-select" id="user_status" name="user[status]">
          <option value="">Please Select</option>
        </select>
      </div>
    HTML
    assert_equivalent_xml expected, @builder.grouped_collection_select(:status, [], :last, :first, :to_s, :to_s, { prompt: "Please Select" }, class: "my-select")
  end

  test "date selects are wrapped correctly" do
    Timecop.freeze(Time.utc(2012, 2, 3)) do
      expected = <<-HTML.strip_heredoc
        <div class="form-group">
          <label for="user_misc">Misc</label>
          <div class="rails-bootstrap-forms-date-select">
            <select class="form-control" id="user_misc_1i" name="user[misc(1i)]">
              #{options_range(start: 2007, stop: 2017, selected: 2012)}
            </select>
            <select class="form-control" id="user_misc_2i" name="user[misc(2i)]">
              #{options_range(start: 1, stop: 12, selected: 2, months: true)}
            </select>
            <select class="form-control" id="user_misc_3i" name="user[misc(3i)]">
              #{options_range(start: 1, stop: 31, selected: 3)}
            </select>
          </div>
        </div>
      HTML
      assert_equivalent_xml expected, @builder.date_select(:misc)
    end
  end

  test "date selects are wrapped correctly with wrapper class" do
    Timecop.freeze(Time.utc(2012, 2, 3)) do
      expected = <<-HTML.strip_heredoc
        <div class="form-group none-margin">
          <label for="user_misc">Misc</label>
          <div class="rails-bootstrap-forms-date-select">
            <select class="form-control" id="user_misc_1i" name="user[misc(1i)]">
              #{options_range(start: 2007, stop: 2017, selected: 2012)}
            </select>
            <select class="form-control" id="user_misc_2i" name="user[misc(2i)]">
              #{options_range(start: 1, stop: 12, selected: 2, months: true)}
            </select>
            <select class="form-control" id="user_misc_3i" name="user[misc(3i)]">
              #{options_range(start: 1, stop: 31, selected: 3)}
            </select>
          </div>
        </div>
      HTML
      assert_equivalent_xml expected, @builder.date_select(:misc, wrapper_class: "none-margin")
    end
  end
  
  test "date selects inline when layout is horizontal" do
    Timecop.freeze(Time.utc(2012, 2, 3)) do
      expected = <<-HTML.strip_heredoc
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post" role="form">
        <input name="utf8" type="hidden" value="&#x2713;"/>
        <div class="form-group row">
          <label class="col-form-label col-sm-2" for="user_misc">Misc</label>
          <div class="col-sm-10">
            <div class="rails-bootstrap-forms-date-select form-inline">
              <select class="form-control" id="user_misc_1i" name="user[misc(1i)]">
                #{options_range(start: 2007, stop: 2017, selected: 2012)}
              </select>
              <select class="form-control" id="user_misc_2i" name="user[misc(2i)]">
                #{options_range(start: 1, stop: 12, selected: 2, months: true)}
              </select>
              <select class="form-control" id="user_misc_3i" name="user[misc(3i)]">
                #{options_range(start: 1, stop: 31, selected: 3)}
              </select>
            </div>
          </div>
        </div>
      </form>
      HTML
      assert_equivalent_xml expected, bootstrap_form_for(@user, layout: :horizontal) { |f| f.date_select(:misc) }
    end
  end

  test "date selects are wrapped correctly with error" do
    @user.errors.add(:misc, "error for test")
    Timecop.freeze(Time.utc(2012, 2, 3)) do
      expected = <<-HTML.strip_heredoc
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post" role="form">
        <input name="utf8" type="hidden" value="&#x2713;"/>
        <div class="form-group">
          <label for="user_misc">Misc</label>
          <div class="rails-bootstrap-forms-date-select">
            <select class="form-control is-invalid" id="user_misc_1i" name="user[misc(1i)]">
              #{options_range(start: 2007, stop: 2017, selected: 2012)}
            </select>
            <select class="form-control is-invalid" id="user_misc_2i" name="user[misc(2i)]">
              #{options_range(start: 1, stop: 12, selected: 2, months: true)}
            </select>
            <select class="form-control is-invalid" id="user_misc_3i" name="user[misc(3i)]">
              #{options_range(start: 1, stop: 31, selected: 3)}
            </select>
            <div class="invalid-feedback">error for test</div>
          </div>
        </div>
      </form>
      HTML
      assert_equivalent_xml expected, bootstrap_form_for(@user) { |f| f.date_select(:misc) }
    end
  end

  test "date selects with options are wrapped correctly" do
    Timecop.freeze(Time.utc(2012, 2, 3)) do
      expected = <<-HTML.strip_heredoc
        <div class="form-group">
          <label for="user_misc">Misc</label>
          <div class="rails-bootstrap-forms-date-select">
            <select class="form-control" id="user_misc_1i" name="user[misc(1i)]">
              <option value=""></option>
              #{options_range(start: 2007, stop: 2017)}
            </select>
            <select class="form-control" id="user_misc_2i" name="user[misc(2i)]">
              <option value=""></option>
              #{options_range(start: 1, stop: 12, months: true)}
            </select>
            <select class="form-control" id="user_misc_3i" name="user[misc(3i)]">
              <option value=""></option>
              #{options_range(start: 1, stop: 31)}
            </select>
          </div>
        </div>
      HTML

      assert_equivalent_xml expected, @builder.date_select(:misc, include_blank: true)
    end
  end

  test "date selects with options and html_options are wrapped correctly" do
    Timecop.freeze(Time.utc(2012, 2, 3)) do
      expected = <<-HTML.strip_heredoc
        <div class="form-group">
          <label for="user_misc">Misc</label>
          <div class="rails-bootstrap-forms-date-select">
            <select class="form-control my-date-select" id="user_misc_1i" name="user[misc(1i)]">
              <option value=""></option>
              #{options_range(start: 2007, stop: 2017)}
            </select>
            <select class="form-control my-date-select" id="user_misc_2i" name="user[misc(2i)]">
              <option value=""></option>
              #{options_range(start: 1, stop: 12, months: true)}
            </select>
            <select class="form-control my-date-select" id="user_misc_3i" name="user[misc(3i)]">
              <option value=""></option>
              #{options_range(start: 1, stop: 31)}
            </select>
          </div>
        </div>
      HTML
      assert_equivalent_xml expected, @builder.date_select(:misc, { include_blank: true }, class: "my-date-select")
    end
  end

  test "time selects are wrapped correctly" do
    Timecop.freeze(Time.utc(2012, 2, 3, 12, 0, 0)) do
      expected = <<-HTML.strip_heredoc
        <div class="form-group">
          <label for="user_misc">Misc</label>
          <div class="rails-bootstrap-forms-time-select">
            <input id="user_misc_1i" name="user[misc(1i)]" type="hidden" value="2012" />
            <input id="user_misc_2i" name="user[misc(2i)]" type="hidden" value="2" />
            <input id="user_misc_3i" name="user[misc(3i)]" type="hidden" value="3" />
            <select class="form-control" id="user_misc_4i" name="user[misc(4i)]">
              #{options_range(start: "00", stop: "23", selected: "12")}
            </select>
            :
            <select class="form-control" id="user_misc_5i" name="user[misc(5i)]">
              #{options_range(start: "00", stop: "59", selected: "00")}
            </select>
          </div>
        </div>
      HTML
      assert_equivalent_xml expected, @builder.time_select(:misc)
    end
  end

  test "time selects are wrapped correctly with error" do
    @user.errors.add(:misc, "error for test")
    Timecop.freeze(Time.utc(2012, 2, 3, 12, 0, 0)) do
      expected = <<-HTML.strip_heredoc
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post" role="form">
        <input name="utf8" type="hidden" value="&#x2713;"/>
        <div class="form-group">
          <label for="user_misc">Misc</label>
          <div class="rails-bootstrap-forms-time-select">
            <input id="user_misc_1i" name="user[misc(1i)]" type="hidden" value="2012" />
            <input id="user_misc_2i" name="user[misc(2i)]" type="hidden" value="2" />
            <input id="user_misc_3i" name="user[misc(3i)]" type="hidden" value="3" />
            <select class="form-control is-invalid" id="user_misc_4i" name="user[misc(4i)]">
              #{options_range(start: "00", stop: "23", selected: "12")}
            </select>
            :
            <select class="form-control is-invalid" id="user_misc_5i" name="user[misc(5i)]">
              #{options_range(start: "00", stop: "59", selected: "00")}
            </select>
            <div class="invalid-feedback">error for test</div>
          </div>
        </div>
      </form>
      HTML
      assert_equivalent_xml expected, bootstrap_form_for(@user) { |f| f.time_select(:misc) }
    end
  end

  test "time selects with options are wrapped correctly" do
    Timecop.freeze(Time.utc(2012, 2, 3, 12, 0, 0)) do
      expected = <<-HTML.strip_heredoc
        <div class="form-group">
          <label for="user_misc">Misc</label>
          <div class="rails-bootstrap-forms-time-select">
            <input id="user_misc_1i" name="user[misc(1i)]" type="hidden" value="1" />
            <input id="user_misc_2i" name="user[misc(2i)]" type="hidden" value="1" />
            <input id="user_misc_3i" name="user[misc(3i)]" type="hidden" value="1" />
            <select class="form-control" id="user_misc_4i" name="user[misc(4i)]">
              <option value=""></option>
              #{options_range(start: "00", stop: "23")}
            </select>
            :
            <select class="form-control" id="user_misc_5i" name="user[misc(5i)]">
              <option value=""></option>
              #{options_range(start: "00", stop: "59")}
            </select>
          </div>
        </div>
      HTML
      assert_equivalent_xml expected, @builder.time_select(:misc, include_blank: true)
    end
  end

  test "time selects with options and html_options are wrapped correctly" do
    Timecop.freeze(Time.utc(2012, 2, 3, 12, 0, 0)) do
      expected = <<-HTML.strip_heredoc
        <div class="form-group">
          <label for="user_misc">Misc</label>
          <div class="rails-bootstrap-forms-time-select">
            <input id="user_misc_1i" name="user[misc(1i)]" type="hidden" value="1" />
            <input id="user_misc_2i" name="user[misc(2i)]" type="hidden" value="1" />
            <input id="user_misc_3i" name="user[misc(3i)]" type="hidden" value="1" />
            <select class="form-control my-time-select" id="user_misc_4i" name="user[misc(4i)]">
              <option value=""></option>
              #{options_range(start: "00", stop: "23")}
            </select>
            :
            <select class="form-control my-time-select" id="user_misc_5i" name="user[misc(5i)]">
              <option value=""></option>
              #{options_range(start: "00", stop: "59")}
            </select>
          </div>
        </div>
      HTML
      assert_equivalent_xml expected, @builder.time_select(:misc, { include_blank: true }, class: "my-time-select")
    end
  end

  test "datetime selects are wrapped correctly" do
    Timecop.freeze(Time.utc(2012, 2, 3, 12, 0, 0)) do
      expected = <<-HTML.strip_heredoc
        <div class="form-group">
          <label for="user_misc">Misc</label>
          <div class="rails-bootstrap-forms-datetime-select">
            <select class="form-control" id="user_misc_1i" name="user[misc(1i)]">
              #{options_range(start: 2007, stop: 2017, selected: 2012)}
            </select>
            <select class="form-control" id="user_misc_2i" name="user[misc(2i)]">
              #{options_range(start: 1, stop: 12, selected: 2, months: true)}
            </select>
            <select class="form-control" id="user_misc_3i" name="user[misc(3i)]">
              #{options_range(start: 1, stop: 31, selected: 3)}
            </select>
            &mdash;
            <select class="form-control" id="user_misc_4i" name="user[misc(4i)]">
              #{options_range(start: "00", stop: "23", selected: "12")}
            </select>
            :
            <select class="form-control" id="user_misc_5i" name="user[misc(5i)]">
              #{options_range(start: "00", stop: "59", selected: "00")}
            </select>
          </div>
        </div>
      HTML
      assert_equivalent_xml expected, @builder.datetime_select(:misc)
    end
  end

  test "datetime selects are wrapped correctly with error" do
    @user.errors.add(:misc, "error for test")
    Timecop.freeze(Time.utc(2012, 2, 3, 12, 0, 0)) do
      expected = <<-HTML.strip_heredoc
      <form accept-charset="UTF-8" action="/users" class="new_user" id="new_user" method="post" role="form">
        <input name="utf8" type="hidden" value="&#x2713;"/>
        <div class="form-group">
          <label for="user_misc">Misc</label>
          <div class="rails-bootstrap-forms-datetime-select">
            <select class="form-control is-invalid" id="user_misc_1i" name="user[misc(1i)]">
              #{options_range(start: 2007, stop: 2017, selected: 2012)}
            </select>
            <select class="form-control is-invalid" id="user_misc_2i" name="user[misc(2i)]">
              #{options_range(start: 1, stop: 12, selected: 2, months: true)}
            </select>
            <select class="form-control is-invalid" id="user_misc_3i" name="user[misc(3i)]">
              #{options_range(start: 1, stop: 31, selected: 3)}
            </select>
            &mdash;
            <select class="form-control is-invalid" id="user_misc_4i" name="user[misc(4i)]">
              #{options_range(start: "00", stop: "23", selected: "12")}
            </select>
            :
            <select class="form-control is-invalid" id="user_misc_5i" name="user[misc(5i)]">
              #{options_range(start: "00", stop: "59", selected: "00")}
            </select>
            <div class="invalid-feedback">error for test</div>
          </div>
        </div>
      </form>
      HTML
      assert_equivalent_xml expected, bootstrap_form_for(@user) { |f| f.datetime_select(:misc) }
    end
  end

  test "datetime selects with options are wrapped correctly" do
    Timecop.freeze(Time.utc(2012, 2, 3, 12, 0, 0)) do
      expected = <<-HTML.strip_heredoc
        <div class="form-group">
          <label for="user_misc">Misc</label>
          <div class="rails-bootstrap-forms-datetime-select">
            <select class="form-control" id="user_misc_1i" name="user[misc(1i)]">
              <option value=""></option>
              #{options_range(start: 2007, stop: 2017)}
            </select>
            <select class="form-control" id="user_misc_2i" name="user[misc(2i)]">
              <option value=""></option>
              #{options_range(start: 1, stop: 12, months: true)}
            </select>
            <select class="form-control" id="user_misc_3i" name="user[misc(3i)]">
              <option value=""></option>
              #{options_range(start: 1, stop: 31)}
            </select>
            &mdash;
            <select class="form-control" id="user_misc_4i" name="user[misc(4i)]">
              <option value=""></option>
              #{options_range(start: "00", stop: "23")}
            </select>
            :
            <select class="form-control" id="user_misc_5i" name="user[misc(5i)]">
              <option value=""></option>
              #{options_range(start: "00", stop: "59")}
            </select>
          </div>
        </div>
      HTML
      assert_equivalent_xml expected, @builder.datetime_select(:misc, include_blank: true)
    end
  end

  test "datetime selects with options and html_options are wrapped correctly" do
    Timecop.freeze(Time.utc(2012, 2, 3, 12, 0, 0)) do
      expected = <<-HTML.strip_heredoc
        <div class="form-group">
          <label for="user_misc">Misc</label>
          <div class="rails-bootstrap-forms-datetime-select">
            <select class="form-control my-datetime-select" id="user_misc_1i" name="user[misc(1i)]">
              <option value=""></option>
              #{options_range(start: 2007, stop: 2017)}
            </select>
            <select class="form-control my-datetime-select" id="user_misc_2i" name="user[misc(2i)]">
              <option value=""></option>
              #{options_range(start: 1, stop: 12, months: true)}
            </select>
            <select class="form-control my-datetime-select" id="user_misc_3i" name="user[misc(3i)]">
              <option value=""></option>
              #{options_range(start: 1, stop: 31)}
            </select>
            &mdash;
            <select class="form-control my-datetime-select" id="user_misc_4i" name="user[misc(4i)]">
              <option value=""></option>
              #{options_range(start: "00", stop: "23")}
            </select>
            :
            <select class="form-control my-datetime-select" id="user_misc_5i" name="user[misc(5i)]">
              <option value=""></option>
              #{options_range(start: "00", stop: "59")}
            </select>
          </div>
        </div>
      HTML
      assert_equivalent_xml expected, @builder.datetime_select(:misc, { include_blank: true }, class: "my-datetime-select")
    end
  end
end
