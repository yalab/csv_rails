$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "csv_rails/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "csv_rails"
  s.version     = CsvRails::VERSION
  s.authors     = ["yalab"]
  s.email       = ["rudeboyjet@gmail.com"]
  s.homepage    = "https://github.com/yalab/csv_rails"
  s.summary     = "A rails plugin for download csv."
  s.description = "The csv_rails gem provides a download csv file with rails."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "3.0.12"

  s.add_development_dependency "sqlite3"
  s.licenses = ['MIT']
end
