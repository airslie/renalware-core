# frozen_string_literal: false

# rubocop:disable Style/ExpandPathArguments,Style/SpecialGlobalVars
$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "renalware/version_number"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "renalware-core"
  s.version     = Renalware::VersionNumber::VERSION
  s.authors     = ["Airslie"]
  s.email       = ["dev@airslie.com"]
  s.homepage    = "https://github.com/airslie/renalware-core"
  s.summary     = "Renalware core functionality as a mountable engine."
  s.description = "Renalware uses demographic, clinical, pathology, and nephrology datasets to "\
                  "improve patient care, undertake clinical and administrative audits and share "\
                  "data with external systems."
  s.license     = "MIT"

  # Note that no spec or feature files are included, so no dummy data is shipped with the gem
  s.files = Dir[
    "{app,config,db,lib}/**/*",
    "vendor/assets/**/*",
    "spec/factories/**/*",
    "spec/support/**/*",
    "Rakefile",
    "README.md",
    "MIT-LICENSE"
  ]

  s.add_dependency "activerecord-import", "~> 0.28.0"
  s.add_dependency "activerecord-postgres_enum", "~> 0.6.0"
  s.add_dependency "active_type", "~> 0.7.1"
  s.add_dependency "ahoy_matey", "~> 2.1"
  s.add_dependency "attr_extras", "~> 6.2"
  s.add_dependency "autoprefixer-rails", "~> 9.6"
  s.add_dependency "chartkick", "~> 3.3"
  s.add_dependency "client_side_validations", "~> 16.0"
  s.add_dependency "client_side_validations-simple_form", "~> 9.0"
  s.add_dependency "clipboard-rails", "~> 1.7.1"
  s.add_dependency "cocoon", "~> 1.2.11"
  s.add_dependency "concurrent-ruby", "~> 1.1.6"
  s.add_dependency "cronex", "~> 0.6.1"
  s.add_dependency "delayed_job", "~> 4.1.4"
  s.add_dependency "delayed_job_active_record", "~> 4.1.2"
  s.add_dependency "delayed_job_web", "~> 1.4.3"
  s.add_dependency "devise", "~> 4.7.1"
  s.add_dependency "devise-security", "~> 0.14.3"
  s.add_dependency "dotenv-rails", "~> 2.5"
  s.add_dependency "dumb_delegator", "~> 0.8.0"
  s.add_dependency "email_validator", "> 1.6.0"
  s.add_dependency "enumerize", "~> 2.3.1"
  s.add_dependency "font-awesome-sass", "~> 5.6" # See icons here: https://fortawesome.github.io/Font-Awesome/icons/
  s.add_dependency "foundation-rails", "~> 5.5.3.2"
  s.add_dependency "friendly_id", "~> 5.3.0"
  s.add_dependency "groupdate", ">= 4.2", "< 6"
  s.add_dependency "hashdiff", "~> 1.0"
  s.add_dependency "httparty", "~> 0.16"
  # Note that upgrading i18n 1.8+ requires altering arguments in HandleBlankValue.
  # A previous attempt to do this however lead to segmentation faults.
  s.add_dependency "i18n", "1.5.3"
  s.add_dependency "jbuilder", "~> 2.8"
  s.add_dependency "jquery-datatables-rails", "~> 3.4.0"
  s.add_dependency "jquery-rails", "~> 4.4.0"
  s.add_dependency "jquery-ui-rails", "~> 6.0.1"
  s.add_dependency "kaminari", "~> 1.1"
  s.add_dependency "liquid", "~> 4.0.0"
  s.add_dependency "lograge", "~> 0.11.2"
  s.add_dependency "naught", "~> 1.1.0"
  s.add_dependency "nested_form", "~> 0.3.2"
  s.add_dependency "nokogiri", "~> 1.9"
  s.add_dependency "ox", "~> 2.11"
  s.add_dependency "pagy", "~> 3.8"
  s.add_dependency "pandoc-ruby", "~> 2.1.4"
  s.add_dependency "paper_trail"
  s.add_dependency "paranoia", "~> 2.4.0"
  s.add_dependency "pdf-reader", "~> 2.4.0"
  s.add_dependency "pg", "~> 1.1"
  s.add_dependency "prawn", "~> 2.2"
  s.add_dependency "puma", "~> 4.3.0"
  s.add_dependency "pundit", "~> 2.1.0"
  s.add_dependency "rack", "~> 2.0"
  s.add_dependency "rack-attack"
  s.add_dependency "rails", "> 5.2", "< 6.2"
  s.add_dependency "ransack", "~> 2.3.0"
  s.add_dependency "record_tag_helper", "~> 1.0.0"
  s.add_dependency "renalware-forms", ">= 0.1.5"
  s.add_dependency "ruby-hl7", "~> 1.2.0"
  s.add_dependency "rubyzip", "~> 1.3.0"
  s.add_dependency "sassc-rails", "~> 2.1.0"
  s.add_dependency "scenic", "~> 1.4"
  s.add_dependency "simple_form", "~> 5.0"
  s.add_dependency "sinatra", "~> 2.0.5"
  s.add_dependency "slim-rails", "~> 3.2.0"
  s.add_dependency "sprockets-rails"
  s.add_dependency "uglifier", "~> 4.2"
  s.add_dependency "validates_timeliness", "~> 4.1.0"
  s.add_dependency "view_component", "~> 2.15"
  s.add_dependency "virtus", "~> 1.0.5"
  s.add_dependency "whenever" # For managing/deploying cron jobs see config/schedule.rb
  s.add_dependency "wicked_pdf"
  s.add_dependency "wisper", "~> 2.0.0"
  s.add_dependency "wisper-activejob", "~> 1.0.0"
  s.add_dependency "wkhtmltopdf-binary", "0.12.3.1"
  s.add_dependency "yard", ">= 0.9.20"
end
# rubocop:enable Style/ExpandPathArguments,Style/SpecialGlobalVars
