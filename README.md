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

To use the automation script locally on your machine:

* Clone the repository
* Run `bundle install`
* Update the values in `.env.sample` and rename it to `.env`. (See (Environment Variables)[#environment-variables] for a description of the values)
* Run `bundle exec ruby bin/declare`
* The script will output `Sent from successfully` or report what went wrong at the conclusion of its execution

### Environment Variables

You need to provide three environment variables for the automation script:

* `USERNAME`: Your username you obtained from the Ministry of Education
* `PASSWORD`: Your password you obtained from the Ministry of Education
* `URL`: The unique school website entry point provided by tik-tak, i.e. (`https://my_school.tik-tak.net/enter_tofes_briut`)

### Headless Browsing

The script is set to run in `headless` mode as it navigates to the school website and fills out the form, which means you won't see it complete the process. If you wish, you can set `headless` to `false` and watch it from your computer as it happens instead. To do so open up `declare.rb` and on line 14 change the code to:

```ruby
browser = Watir::Browser.new :chrome, headless: false
```

### Send SMS Update

This script also provides the ability to send an SMS update after completion. To enable this feature you will need to have a [Vonage Account](https://dashboard.nexmo.com) and provide the following additional values in your `.env` file:

* `SEND_SMS=true`: A boolean set to true to enable the SMS feature
* `VONAGE_API_KEY`: Set this to your Vonage API key
* `VONAGE_API_SECRET`: Set this to your Vonage API secret
* `VONAGE_NUMBER`: Set this to the phone number you provisioned from Vonage for SMS delivery
* `TO_NUMBER`: Set this to the receipient number for the SMS to be delivered to

## Contributing

Contributions to the code are always welcome. You can either raise an issue to be discussed or submit a pull request directly. We try to follow the [GitHub Flow](https://guides.github.com/introduction/flow/) when proposing new features.

## License

This script is under the [MIT License](LICENSE.txt).
