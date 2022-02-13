# School Health Declaration Automation Script

This is an automation script that will fill out the school's daily health declaration requirement for each child in the parent portal dashboard.

It can be run manually or can be connected to a scheduler to run once a day.

## How To Use

### Using The Gem

You can use this software as a Ruby gem by downloading it to your machine from Rubygems:

From the command line:
* `gem install school_declare`

In your `Gemfile`:
* `gem 'school_declare'`

### Using The Code

You can use this script to either send:

* Daily health declaration (*No longer required*)
* Twice weekly antigen test declaration

#### Daily health declaration automation

To use the automation script locally on your machine:

* Clone the repository
* Run `bundle install`
* Update the following values in `.env.sample` and rename it to `.env`. (See (Environment Variables)[#environment-variables] for a description of the values)
  * USERNAME
  * PASSWORD
  * URL
* Run `bundle exec ruby bin/declare`
* The script will output `Sent from successfully` or report what went wrong at the conclusion of its execution

#### Twice weekly antigen test declaration

To use the antigen test declaration automation script locally on your machine:

* Clone the repository
* Run `bundle install`
* Update the following values in `.env.sample` and rename it to `.env`. (See (Environment Variables)[#environment-variables] for a description of the values)
  * URL
  * PARENT_TZ
  * PARENT_NAME
  * CHILDRENS_TZ
  * CHILDRENS_NAMES
* Run `bundle exec ruby bin/declare_antigen`
* The script will output `Sent from successfully` or report what went wrong at the conclusion of its execution

### Environment Variables

You need to provide three environment variables for the daily automation script:

* `USERNAME`: Your username you obtained from the Ministry of Education
* `PASSWORD`: Your password you obtained from the Ministry of Education
* `URL`: The unique school website entry point provided by tik-tak, i.e. (`https://my_school.tik-tak.net/enter_tofes_briut`)

You need to provide the following environment variables for the twice weekly antigen test declaration form script:

  * `URL`: The URL for the antigen test declaration, i.e. (`https://apps.education.gov.il/NmmNetAnt/Antigen`)
  * `PARENT_TZ`: A parent's teudat zehut number
  * `PARENT_NAME`: A parent's name **in Hebrew**
  * `CHILDRENS_TZ`: The teudat zehut number or numbers of the child/children. **If more than one child, separate with a single "," and NO SPACE.**
  * `CHILDRENS_NAMES`: The name of names of the child/children. **If more than one child, separate with a cingle "," and NO SPACE.**

### Headless Browsing

The script is set to run in `headless` mode as it navigates to the school website and fills out the form, which means you won't see it complete the process. If you wish, you can set `headless` to `false` and watch it from your computer as it happens instead. To do so open up `declare.rb` and on line 14 or `declare_antigen.rb` on line 45 and change the code to:

```ruby
browser = Watir::Browser.new :chrome, headless: false
```

## Contributing

Contributions to the code are always welcome. You can either raise an issue to be discussed or submit a pull request directly. We try to follow the [GitHub Flow](https://guides.github.com/introduction/flow/) when proposing new features.

## License

This script is under the [MIT License](LICENSE.txt).
