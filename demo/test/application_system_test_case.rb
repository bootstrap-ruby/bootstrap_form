require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  include Capybara::Screenshot::Diff

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

  driven_by :selenium, using: :chrome, screen_size: [960, 720], options: options do |capabilities|
    capabilities.add_argument "force-device-scale-factor=1"
    capabilities.add_argument "lang=#{ENV.fetch('LANG', 'en_CA')}"
  end

  if remote_selenium?
    Capybara.server_host = "0.0.0.0"
    Capybara.server_port = ENV.fetch("TEST_APP_PORT", 3001)
    Capybara.app_host = "http://#{ENV.fetch('TEST_APP_HOST', 'shell')}:#{ENV.fetch('TEST_APP_PORT', Capybara.server_port)}"
  end

  Capybara::Screenshot.enabled = ENV["CI"].blank?
  Capybara.server = :puma, { Silent: true }
end
