require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  include Capybara::Screenshot::Diff
  driven_by :selenium, using: :headless_chrome, screen_size: [960, 720] do |capabilities|
    capabilities.add_argument "force-device-scale-factor=1"
  end
end
