# frozen_string_literal: true

require 'dotenv'
Dotenv.load!

require 'nokogiri'
require 'webdrivers/chromedriver'
require 'watir'

class Declare
  attr_reader :url, :username, :password

  def self.call
    new.call
  end

  def initialize(url: ENV['URL'], username: ENV['USERNAME'], password: ENV['PASSWORD'])
    @url = url
    @username = username
    @password = password
  end

  def call
    get_sign_in_page
  end

  def get_sign_in_page
    browser = Watir::Browser.new :chrome, headless: false
    browser.goto(@url)

    click_first_sign_in(browser)
  end

  def click_first_sign_in(page)
    page.link(class: %w[
                text-bold
                color-white
                edu-connect
                btn
                color-blue
                border-blue
                btn-connect-briut
              ]).click

    fill_in_sign_in_form(page)
  end

  def fill_in_sign_in_form(page)
    page.div(id: 'blocker').click
    page.send_keys(:tab)
    page.text_field(xpath: '/html/body/section/div[1]/div[3]/form/fieldset/input[2]').set(@username)
    page.text_field(xpath: '/html/body/section/div[1]/div[3]/form/fieldset/span/input[3]').set(@password)
    page.button(text: 'כניסה').click

    fill_out_declaration(page)
  end

  def fill_out_declaration(page)
    kids = page.divs(:class => /name_student_infile/)
    kids.each do |kid|
      if check_already_submitted?(kid)
        puts 'Form already submited'
        next
      end
      kid.click if kid.href
      complete_individual_form(page)
    end
  end

  def complete_individual_form(page)
    # two checkboxes
    # THESE HAVE BEEN REMOVED FROM THE FORM (maybe temporarily?)
    # page.label(xpath: '/html/body/div[1]/section/div/div[3]/form/div/div[2]/b/div[2]/div/label').click
    # page.label(xpath: '/html/body/div[1]/section/div/div[3]/form/div/div[2]/b/div[3]/p/label').click

    # canvas element
    canvas = page.browser.driver.find_element(xpath: '/html/body/div[1]/section/div/div[3]/form/div/div[2]/div[5]/div[1]/div/canvas')
    page.browser.driver.action.move_to(canvas, 50, 20).click_and_hold.move_to(canvas, 50, 85).perform
    page.browser.driver.action.move_to(canvas, 200, 85).click_and_hold.move_to(canvas, 75, 43).perform
    page.browser.driver.action.move_to(canvas, 100, 34).click_and_hold.move_to(canvas, 264, 81).perform
    page.browser.driver.action.move_to(canvas, 73, 64).click_and_hold.move_to(canvas, 387, 39).perform

    page.button(id: /btn_send/).click

    validate_success(page)
  end

  def validate_success(page)
    check_for_errors(page)

    puts 'Sent form successfully' if page.label(class: /answer_send color-red/).present?
  end

  def check_for_errors(page)
    puts 'First checkbox not checked properly' if page.label(class: /fill_answer1 color-red/).present?

    puts 'Second checkbox not checked properly' if page.label(class: /fill_answer2 color-red/).present?

    puts 'Signature not recorded properly' if page.label(class: /fill_sign color-red/).present?

    puts 'Form not sent successfully' if page.label(class: /answer_send color-red hidden/).present?
  end

  def check_already_submitted?(kid)
    kid.link(:class => /answer_send/).present?
  end
end
