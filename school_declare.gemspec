$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require_relative "lib/declare/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "school_declare"
  spec.version     = Declare::VERSION
  spec.authors     = ["Ben Greenberg"]
  spec.email       = ["ben.greenberg@hey.com"]
  spec.homepage    = "https://github.com/bencgreenberg/school-health-declaration-automation"
  spec.summary     = "Automate the sending of health declaration forms for Israeli schools."
  spec.description = "A gem to help send the daily health forms for Israeli schools."
  spec.license     = "MIT"
  spec.executables   << 'declare'

  spec.files = Dir["{lib}/**/*", "LICENSE.txt", "README.md", "{bin}/**/*"]

  spec.metadata = {
    'homepage' => 'https://github.com/bencgreenberg/school-health-declaration-automation',
    'source_code_uri' => 'https://github.com/bencgreenberg/school-health-declaration-automation',
    'bug_tracker_uri' => 'https://github.com/bencgreenberg/school-health-declaration-automation/issues'
  }
end