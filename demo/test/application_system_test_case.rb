require "test_helper"
require "capybara_screenshot_diff/minitest"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  include Capybara::Screenshot::Diff
  include CapybaraScreenshotDiff::DSL

  class << self
    def remote_selenium? = @remote_selenium ||= ENV["SELENIUM_HOST"].present? || ENV["SELENIUM_PORT"].present?
  end

  options = if remote_selenium?
              {
                browser: :remote,
                url: "http://#{ENV.fetch('SELENIUM_HOST', 'selenium')}:#{ENV.fetch('SELENIUM_PORT', '4444')}"
              }
            else
              {}
            end

  driven_by :selenium, using: :headless_chrome, screen_size: [960, 720], options: options do |capabilities|
    capabilities.add_argument("force-device-scale-factor=1")
    capabilities.add_argument("lang=#{ENV.fetch('LANG', 'en_CA')}")
    # Needed for Selenium 129. Presumably remove at some point.
    capabilities.add_argument("--headless=old")
  end

  if remote_selenium?
    Capybara.server_host = "0.0.0.0"
    Capybara.server_port = ENV.fetch("TEST_APP_PORT", 3001)
    Capybara.app_host = "http://#{ENV.fetch('TEST_APP_HOST', 'shell')}:#{ENV.fetch('TEST_APP_PORT', Capybara.server_port)}"
  end

  Capybara::Screenshot.enabled = true
  Capybara::Screenshot::Diff.driver = ENV.fetch("SCREENSHOT_DRIVER", "chunky_png").to_sym

  Capybara.server = :puma, { Silent: true }
end
