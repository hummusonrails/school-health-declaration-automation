# frozen_string_literal: true

require 'dotenv'
Dotenv.load!

require 'nokogiri'
require 'webdrivers/chromedriver'
require 'watir'
require 'useragents'
require 'selenium-webdriver'

# Declare antigen test health declaration for schools.
#
# @example
#
# DeclareAntigen.new.call
class DeclareAntigen
  attr_reader :url, :parent_tz, :parent_name, :childrens_tz, :childrens_names

  def self.call
    new.call
  end

  def initialize(url: ENV['URL'], parent_tz: ENV['PARENT_TZ'], parent_name: ENV['PARENT_NAME'], childrens_tz: ENV['CHILDRENS_TZ'], childrens_names: ENV['CHILDRENS_NAMES'])
    @url = url
    @parent_tz = parent_tz
    @parent_name = parent_name
    @childrens_tz = childrens_tz.include?(',') ? childrens_tz.split(',') : childrens_tz
    @childrens_names = childrens_names.include?(',') ? childrens_names.split(',') : childrens_names

    validate!
  end

  def validate!
    raise ArgumentError, 'Missing URL environment variable' unless ENV['URL']
    raise ArgumentError, 'Missing PARENT_NAME environment variable' unless ENV['PARENT_NAME']
    raise ArgumentError, 'Missing PARENT_TZ environment variable' unless ENV['PARENT_TZ']
    raise ArgumentError, 'Missing CHILDRENS_TZ environment variable' unless ENV['CHILDRENS_TZ']
    raise ArgumentError, 'Missing CHILDRENS_NAMES environment variable' unless ENV['CHILDRENS_NAMES']
  end

  def call
    go_to_form
  end

  def go_to_form
    agent = UserAgents.rand()
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--headless')
    options.add_argument('--disable-gpu')
    options.add_argument('--window-size=1200x600')
    options.add_argument('--disable-infobars')
    options.add_argument('--start-maximized')
    options.add_argument("--disable-blink-features")
    options.add_argument('--disable-blink-features=AutomationControlled')
    options.add_argument("--user-agent='#{agent}'")
    driver = Selenium::WebDriver.for :chrome, options: options
    driver.execute_script("Object.defineProperty(navigator, 'webdriver', {get: () => false})")
    driver.execute_cdp('Network.setUserAgentOverride', userAgent: "'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.53 Safari/537.36'" )
    browser = Watir::Browser.new(driver)
    browser.goto(@url)

    fill_out_form(browser)
  end

  def fill_out_form(page)
    item_count = 0

    if @childrens_tz.is_a?(Array)
      @childrens_tz.count.times do
        complete_individual_form(item_count, page)
        submit_form(page)
        check_for_errors(page)
        item_count += 1
        page.refresh
      end
    else
        complete_individual_form(page)
        submit_form(page)
        check_for_errors
        item_count += 1
    end
  
    validate_success(item_count)
  end

  def complete_individual_form(count = nil, page) # rubocop:disable Metrics/AbcSize
    sleep 2
    page.text_field(id: /txtMisparZehutHore/).wait_until(&:present?).set(@parent_tz)
    sleep 3
    page.text_field(id: /txtShemPratiHore/).wait_until(&:present?).set(@parent_name)
    
    if @childrens_tz.is_a?(Array)
      sleep 2
      page.text_field(class: /mispar-zehut-yeled form-control/).set(@childrens_tz[count])
      sleep 2
      page.text_field(class: /shem-prati-yeled form-control/).set(@childrens_names[count])
      sleep 4
      page.radio(name: /rdoResult_0/).click
    else
      sleep 1
      page.text_field(class: /mispar-zehut-yeled form-control/).set(@childrens_tz)
      sleep 3
      page.text_field(class: /shem-prati-yeled form-control/).set(@childrens_names)
      sleep 2
      page.radio(name: /rdoResult_0/).click
    end
  end

  def submit_form(page)
    until page.div(id: /bot/).exists? do sleep 3 end
    page.execute_script("window.scrollBy(0,200)")
    page.iframe.click
    sleep 5
    page.button(id: /cmdSend/).click
  end

  def validate_success(count)
    message = "Form submitted #{count} times successfully for all children!"
    puts message
  end

  def check_for_errors(page)
    raise 'Something went wrong' if page.div(class: /error-line/).present?
  end
end
