$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "renalware/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "renalware-core"
  s.version     = Renalware::VERSION
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
  s.add_dependency "rails", "~> 5.1.4"
  s.add_dependency "active_type", "~> 0.7.1"
  s.add_dependency "activerecord-import"
  s.add_dependency "attr_extras"
  s.add_dependency "autoprefixer-rails"
  s.add_dependency "chosen-rails"
  s.add_dependency "simple_form"
  s.add_dependency "client_side_validations", "11.0.0"
  s.add_dependency "client_side_validations-simple_form"
  s.add_dependency "clipboard-rails"
  s.add_dependency "cocoon"
  s.add_dependency "cronex"
  s.add_dependency "delayed_job_active_record"
  s.add_dependency "delayed_job_web"
  s.add_dependency "devise"
  s.add_dependency "dotenv-rails"
  s.add_dependency "friendly_id"
  s.add_dependency "lograge"
  s.add_dependency "dumb_delegator"
  s.add_dependency "email_validator"
  s.add_dependency "enumerize"
  s.add_dependency "font-awesome-rails" # See icons here: https://fortawesome.github.io/Font-Awesome/icons/
  s.add_dependency "foundation-rails", "~> 5.5.3.2"
  s.add_dependency "hashdiff"
  s.add_dependency "httparty"
  s.add_dependency "jbuilder"
  s.add_dependency "jquery-datatables-rails", "~> 3.4.0"
  s.add_dependency "jquery-rails"
  s.add_dependency "jquery-ui-rails"
  s.add_dependency "kaminari"
  s.add_dependency "liquid"
  s.add_dependency "naught", "~> 1.1.0"
  s.add_dependency "nested_form"
  s.add_dependency "nokogiri", ">= 1.7.1"
  s.add_dependency "paper_trail"
  s.add_dependency "paranoia"
  s.add_dependency "pg", "~> 0.21.0"
  s.add_dependency "puma"
  s.add_dependency "pundit", "~> 1.1.0"
  s.add_dependency "rack-attack"
  s.add_dependency "ransack"
  s.add_dependency "record_tag_helper", "~> 1.0"
  s.add_dependency "pandoc-ruby"
  s.add_dependency "ruby-hl7", "~> 1.2.0"
  s.add_dependency "sass-rails"
  s.add_dependency "scenic"
  s.add_dependency "yard"
  s.add_dependency "sinatra"
  s.add_dependency "slim-rails"
  s.add_dependency "trix"
  s.add_dependency "uglifier"
  s.add_dependency "underscore-rails"
  s.add_dependency "validates_timeliness"
  s.add_dependency "virtus"
  s.add_dependency "whenever" # For managing and deploying cron jobs - see config/schedule.rb
  s.add_dependency "wicked_pdf", "~> 1.1.0"
  s.add_dependency "wisper"
  s.add_dependency "wkhtmltopdf-binary", "~> 0.12.3"
  s.add_dependency "rails-assets-foundation-datepicker", "1.5.0" # 1.5.6 causes capybara errors
  s.add_dependency "rails-assets-select2", "~> 4.0.2"
end
