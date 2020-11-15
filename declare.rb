require 'dotenv'
Dotenv.load!

require 'nokogiri'
require 'webdrivers/chromedriver'
require 'watir'

def call(url)
  get_sign_in_page(url)
end

def get_sign_in_page(url)
  browser = Watir::Browser.new :chrome, headless: false
  browser.goto(url)

  click_first_sign_in(browser)
end

def click_first_sign_in(page)
  page.link(:class => [
    'text-bold',
    'color-white',
    'edu-connect',
    'btn',
    'color-blue',
    'border-blue',
    'btn-connect-briut'
    ]).click

  fill_in_sign_in_form(page)
end

def fill_in_sign_in_form(page)
  page.div(:id => 'blocker').click
  page.send_keys(:tab)
  page.text_field(:xpath => '/html/body/section/div[1]/div[3]/form/fieldset/input[2]').set(ENV['USERNAME'])
  page.text_field(:xpath => '/html/body/section/div[1]/div[3]/form/fieldset/span/input[3]').set(ENV['PASSWORD'])
  page.button(:text => 'כניסה').click

  fill_out_declaration(page)
end

def fill_out_declaration(page)
  kids_list = page.div(class: /name_student_infile/)
  kids_list.links.each do |kid|
    if check_already_submitted?(page)
      puts "Form already submited"
      next
    end
    kid.click
    complete_individual_form(page)
  end
end

def complete_individual_form(page)
  # two checkboxes
  page.label(:xpath => '/html/body/div[1]/section/div/div[3]/form/div/div[2]/b/div[2]/div/label').click
  page.label(:xpath => '/html/body/div[1]/section/div/div[3]/form/div/div[2]/b/div[3]/p/label').click
  
  # canvas element
  canvas = page.browser.driver.find_element(:xpath => "/html/body/div[1]/section/div/div[3]/form/div/div[2]/b/div[6]/div[1]/div/canvas")
  page.browser.driver.action.move_to(canvas, 50, 20).click_and_hold.move_to(canvas, 550, 85).release.perform
  page.browser.driver.action.move_to(canvas, 200, 85).click_and_hold.move_to(canvas, 75, 43).release.perform
  page.button(id: /btn_send/).click
  
  validate_success(page)
end

def validate_success(page)
  check_for_errors(page)
  
  if page.label(class: /answer_send color-red/).present?
    puts "Sent form successfully"
  end
end

def check_for_errors(page)
  if page.label(class: /fill_answer1 color-red/).present?
    puts "First checkbox not checked properly"
  end

  if page.label(class: /fill_answer2 color-red/).present?
    puts "Second checkbox not checked properly"
  end

  if page.label(class: /fill_sign color-red/).present?
    puts "Signature not recorded properly"
  end

  if page.label(class: /answer_send color-red hidden/).present?
    puts "Form not sent successfully"
  end
end

def check_already_submitted?(page)
  page.link(:class => [
    'answer_send',
    'pdf_wrap_create_briut',
    'padding-right-lg-x',
    'cursor-pointer'
    ]).present?
end

call(ENV['URL'])